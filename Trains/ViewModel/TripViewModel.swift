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

@Observable
final class TripViewModel: Equatable, Hashable, Sendable, Identifiable {
    let trip: Trip
    private(set) var tripError: String?
    private(set) var tripTimes: [TripTime] = []

    @ObservationIgnored private var cancellables: [AnyCancellable] = []
    @ObservationIgnored var isLoading = false
    
    var id: ObjectIdentifier {
        trip.id
    }

    init(trip: Trip) {
        self.trip = trip
        
        // Print some response
        let enc = JSONEncoder()
        enc.outputFormatting = .prettyPrinted
        let json = try! enc.encode(trip.startStop) // swiftlint:disable:this force_try
        TrainLogger.stops.debug("\(String(data: json, encoding: .utf8)!)") // swiftlint:disable:this force_unwrapping
        let json1 = try! enc.encode(trip.endStop) // swiftlint:disable:this force_try
        TrainLogger.stops.debug("\(String(data: json1, encoding: .utf8)!)") // swiftlint:disable:this force_unwrapping
        
        // Load initially
        Task {
            await self.retrieveTrip()
        }
        
        Timer.publish(every: 45, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, !self.isLoading else { return }
                // In the 10 minutes before a train is to arrive, refresh the data and make sure that it is not coming early or cancelled
                guard (self.tripTimes.first?.startTime ?? Date.distantPast).addingTimeInterval(-60 * 10) < Date.now else { return }
                guard trip.lastRefreshedTime.addingTimeInterval(60) < Date.now else { return }
                Task {
                    await self.retrieveTrip()
                }
            }
            .store(in: &cancellables)
    }
    
    func retrieveTrip() async {
        guard !isLoading else { return }
        self.isLoading = true
        do {
            tripTimes = try await TripPlannerManager.retreiveTripTimes(startStopId: self.trip.startStop.stopId, endStopId: self.trip.endStop.stopId)
            self.tripError = ""
            trip.lastRefreshedTime = Date.now
            self.isLoading = false
        } catch {
            self.tripError = "Error: \(error)"
            self.isLoading = false
        }
    }
    
    static func == (lhs: TripViewModel, rhs: TripViewModel) -> Bool {
        lhs.trip.startStop.id == rhs.trip.startStop.id && lhs.trip.endStop.id == rhs.trip.endStop.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trip.startStop.id)
        hasher.combine(trip.endStop.id)
    }
}
