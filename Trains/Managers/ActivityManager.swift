//
//  ActivityManager.swift
//  Trains
//
//  Created by Ali Ali on 5/5/2024.
//

import Foundation
@preconcurrency  import ActivityKit
import UIKit
import FirebaseFirestore

final class ActivityManager: Sendable {
    @MainActor static let actor = ActivityTracker()
}

@MainActor
final class ActivityTracker: Sendable {
    var currentActivity: Activity<LiveTrainsAttributes>?
    
    @MainActor
    func endActivity() async {
        guard currentActivity != nil else {
            TrainLogger.activity.error("Activity Already Nil")
            return
        }
        await currentActivity?.end(.none, dismissalPolicy: .immediate)
        currentActivity = nil
        TrainLogger.activity.debug("Activity Ended")
    }
    
    @MainActor
    func updateActivity(state: LiveTrainsAttributes.ContentState) async {
        guard let currentActivity else {
            TrainLogger.activity.error("Activity Already Nil")
            return
        }
        await currentActivity.update(
            ActivityContent<LiveTrainsAttributes.ContentState>(
                state: state,
                staleDate: state.times.last?.startTime,
                relevanceScore: 50
            ),
            alertConfiguration: AlertConfiguration(title: "Train Trip Updated", body: "trip update", sound: .default)
        )
        TrainLogger.activity.debug("Activity Updated")
    }
    
    @MainActor
    func startActivity(startStop: Stop, endStop: Stop, tripTimes: [TripTime]) async throws {
        let attribute = LiveTrainsAttributes(
            startStop: startStop,
            endStop: endStop
        )
        let initialState = LiveTrainsAttributes.ContentState(times: tripTimes)
        try await startActivity(attribute: attribute, initialState: initialState)
    }
    
    @MainActor
    func startActivity(attribute: LiveTrainsAttributes, initialState: LiveTrainsAttributes.ContentState) async throws {
        await ActivityManager.actor.endActivity()
        currentActivity = try Activity.request(
            attributes: attribute,
            content: .init(state: initialState, staleDate: initialState.times.last?.startTime),
            pushType: .token
        )
        TrainLogger.activity.debug("Activity Started")

        Task {
            guard let activity = ActivityManager.actor.currentActivity else { return }
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await activityState in activity.activityStateUpdates {
                        switch activityState {
                        case .dismissed:
                            TrainLogger.activity.debug("Dismissed")
                        case .ended:
                            await ActivityManager.actor.endActivity()
                            TrainLogger.activity.debug("Ended Activity and cleaned up")
                        case .stale:
                            TrainLogger.activity.debug("Stale: Updating trip times. Before: \(activity.content)")
                            do {
                                let tripTimes = try await TripPlannerManager.retreiveTripTimes(startStopId: activity.attributes.startStop.stopId, endStopId: activity.attributes.endStop.stopId)
                                let state = LiveTrainsAttributes.ContentState(times: tripTimes)
                                await activity.update(
                                    ActivityContent<LiveTrainsAttributes.ContentState>(
                                        state: state,
                                        staleDate: state.times.last?.startTime,
                                        relevanceScore: 50
                                    ),
                                    alertConfiguration: AlertConfiguration(title: "Train Trip Updated", body: "trip update", sound: .default)
                                )
                                
                                TrainLogger.activity.debug("Stale: Updating trip times. After: \(activity.content)")
                            } catch {
                                TrainLogger.activity.error("Stale: Died: \(error)")
                                await ActivityManager.actor.endActivity()
                            }
                        case .active:
                            TrainLogger.activity.debug("Active")
                        @unknown default: break
                        }
                    }
                }
                group.addTask { @MainActor in
                    for await contentState in activity.contentUpdates {
                        TrainLogger.stops.debug("Activity Update: \(contentState.description)")
//                                await self.updateLiveActivityTrips(times: contentState.state.times)
//                                self.currentActivity?.contentState = contentState.state
                    }
                }
                group.addTask { @MainActor in
                    for await pushToken in activity.pushTokenUpdates {
                        let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                        TrainLogger.activity.log("Push token update from stream: \(pushTokenString)")
                        do {
                            let userIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
                            try await Firestore.firestore().collection("pushTokens").document(userIdentifier).setData(["pushToken": pushTokenString], merge: true)
                            TrainLogger.activity.log("Push token from stream saved to server")
                        } catch {
                            TrainLogger.activity.error("\(error)")
                        }
                    }
                }
            }
        }
    }
}
