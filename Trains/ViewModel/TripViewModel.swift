//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Alamofire
import Combine
import ActivityKit
import Apollo
import ApolloAPI

@Observable
final class TripViewModel: Equatable, Hashable, Sendable, Identifiable {
    let trip: Trip
    private(set) var tripError: String?
    private(set) var tripTimes: [TripTime] = []
    
    @ObservationIgnored var currentActivity: Activity<LiveTrainsAttributes>?
    @ObservationIgnored private var isLoading = true
    @ObservationIgnored private var cancellables: [AnyCancellable] = []

    var id: ObjectIdentifier {
        trip.id
    }
    
    init(trip: Trip) {
        self.trip = trip
        guard trip.id != "11" else { return }
        let query = PlanQuery(fromPlace: GraphQLNullable(stringLiteral: "\(trip.startStop.stopName)::\(trip.startStop.gtfsId)"), toPlace: GraphQLNullable(stringLiteral: "\(trip.endStop.stopName)::\(trip.endStop.gtfsId)"), numItineraries: GraphQLNullable(integerLiteral: 10), searchWindow: GraphQLNullable(stringLiteral: "3600"))
        
        let watcher = Network.apolloClient.watch(query: query, cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            guard let self else { return }
            guard let itineraries = try? result.get().data?.plan?.itineraries, !itineraries.isEmpty else {
                if self.tripTimes.last?.startTime ?? Date.distantPast < Date.now {
                    self.tripError = "Failure to retrieve"
                } else {
                    // Some random error but we have some data to work with, lets use it for now
                }
                return
            }
            self.tripTimes = itineraries.compactMap { (itinerary: PlanQuery.Data.Plan.Itinerary?) -> TripTime? in
                guard let itinerary else { return nil }
                let startTime = Double.from(itinerary.startTime) ?? 0
                let endTime = Double.from(itinerary.endTime) ?? 0
                return TripTime(startTime: Date(timeIntervalSince1970: TimeInterval(startTime / 1000)), endTime: Date(timeIntervalSince1970: TimeInterval(endTime / 1000)))
            }
            self.isLoading = false
        }
        
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                watcher.refetch(cachePolicy: .returnCacheDataAndFetch)
            }
            .store(in: &cancellables)
    }
    
    static func == (lhs: TripViewModel, rhs: TripViewModel) -> Bool {
        lhs.trip.startStop.id == rhs.trip.startStop.id && lhs.trip.endStop.id == rhs.trip.endStop.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trip.startStop.id)
        hasher.combine(trip.endStop.id)
    }
}
