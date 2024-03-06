//
//  FavouriteTripViewManager.swift
//  Trains
//
//  Created by Ali Ali on 29/2/2024.
//

import Foundation
import SwiftData

@MainActor
class FavouriteTripViewManager {
    
    static let shared = FavouriteTripViewManager()
    let viewModel: TripViewModel?
    
    init() {
        viewModel = FavouriteTripViewManager.getFavouriteTrip()
    }
    
    @MainActor 
    static private func getFavouriteTrip() -> TripViewModel? {
        guard let container = try? ModelContainer(for: Trip.self, Stop.self) else {
            TrainLogger.stops.debug("Empty Container")
            return nil
        }
        let descriptor = FetchDescriptor<Trip>(predicate: #Predicate { trip in
            trip.favourite == true
        })
        guard let trip = try? container.mainContext.fetch(descriptor).first else {
            guard let firstTrip = try? container.mainContext.fetch(FetchDescriptor<Trip>()).first else {
                return nil
            }
            return TripViewModel(trip: firstTrip)
        }
        return TripViewModel(trip: trip)
    }
}
