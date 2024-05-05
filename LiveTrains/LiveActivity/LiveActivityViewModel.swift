//
//  LiveActivityViewModel.swift
//  Trains
//
//  Created by Ali Ali on 21/2/2024.
//

import Foundation
@preconcurrency import ActivityKit
import os.log
import FirebaseMessaging
import FirebaseFirestore

extension TripViewModel {
    func startLiveActivity(tripTimes: [TripTime]) async {
        guard await ActivityManager.actor.currentActivity == nil else { return }
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                try await ActivityManager.actor.startActivity(
                    startStop: trip.startStop, endStop: trip.endStop, tripTimes: tripTimes
                )
                TrainLogger.stops.debug("Started live activity")
            } catch {
                TrainLogger.stops.error("\(error.localizedDescription)")
            }
        }
    }

    func updateLiveActivityTrips(times: [TripTime]) async {
        await ActivityManager.actor.updateActivity(state: LiveTrainsAttributes.ContentState(times: times))
    }
}
