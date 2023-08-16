//
//  NavigationHelper.swift
//  Trains
//
//  Created by Ali, Ali on 30/7/2023.
//

import Foundation
import OSLog
import GTFS

class CacheManager: ObservableObject {
    enum Constants {
        static let tripsKey = "savedStationDestinations"
    }

    func getStationDestinations() -> [Stop] {
        if let data = UserDefaults.standard.object(forKey: Constants.tripsKey) as? Data,
           let trips = try? JSONDecoder().decode([Stop].self, from: data) {
            return trips
        }
        Logger.network.log("Could not retreive Cache")
        return []
    }

    func saveStationDestinations(_ destinations: [Stop]) {
        if let encoded = try? JSONEncoder().encode(destinations) {
            UserDefaults.standard.set(encoded, forKey: Constants.tripsKey)
        }
    }
}
