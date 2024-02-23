//
//  LiveActivityViewModel.swift
//  Trains
//
//  Created by Ali Ali on 21/2/2024.
//

import Foundation
import ActivityKit
import os.log

extension TripViewModel {

    func startLiveActivity(tripTimes: [TripTime]) {
        guard currentActivity == nil else { return }
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let liveTrain = LiveTrainsAttributes(startStopName: trip.startStop.stopName, endStopName: trip.endStop.stopName)
                let initialState = LiveTrainsAttributes.ContentState(times: tripTimes)
                
                self.currentActivity = try Activity.request(
                    attributes: liveTrain,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil
                )
                TrainLogger.stops.debug("Started live activity")
            } catch {
                TrainLogger.stops.error("\(error)")
            }
        }
    }
    
    func observeFrequentUpdate() {
        Task {
            for await isEnabled in ActivityAuthorizationInfo().frequentPushEnablementUpdates {
                Logger().debug("Frequent")
            }
        }
    }
    
    func updateTrips(times: [TripTime]) async {
        guard let activity = currentActivity else {
            return
        }
        
        let contentState = LiveTrainsAttributes.ContentState(times: times)
        
        await activity.update(
            ActivityContent<LiveTrainsAttributes.ContentState>(
                state: contentState,
                staleDate: nil,
                relevanceScore: 50
            ),
            alertConfiguration: nil
        )
    }
    
    func observeActivityUpdates(_ activity: Activity<LiveTrainsAttributes>) {
        // Observe updates for ongoing Live Activities.
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await content in activity.contentUpdates {
                        Logger().debug("Normal")
//                        self.updateAdventure(content: content)
                        return
                    }
                }
            }
        }
    }
    
    func cleanUp() {
        currentActivity = nil
    }
}
