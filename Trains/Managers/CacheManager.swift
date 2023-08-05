//
//  NavigationHelper.swift
//  Trains
//
//  Created by Ali, Ali on 30/7/2023.
//

import Foundation
import OpenTripPlannerApi
import OSLog

class CacheManager: ObservableObject {
    enum Constants {
        static let tripsKey = "savedTrips"
    }

    func getTrips() -> [TripViewModel] {
        if let data = UserDefaults.standard.object(forKey: Constants.tripsKey) as? Data,
           let trips = try? JSONDecoder().decode([TripViewModel].self, from: data) {
            return trips
        }
        Logger.network.log("Could not retreive Cache")
        return []
    }

    func saveTrips(_ trips: [TripViewModel]) {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: Constants.tripsKey)
        }
    }

//    func getTripTimes() -> TripViewModel {
//        if let data = UserDefaults.standard.object(forKey: Constants.tripsKey) as? Data,
//           let trips = try? JSONDecoder().decode([TripViewModel].self, from: data) {
//            return trips
//        }
//        Logger.network.log("Could not retreive Cache")
//        return []
//    }
//
//    func saveTripTimes(_ tripViewModel: TripViewModel) {
//        if let encoded = try? JSONEncoder().encode(trips) {
//            UserDefaults.standard.set(encoded, forKey: Constants.tripsKey)
//        }
//    }
}
