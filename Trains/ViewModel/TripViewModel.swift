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
    
    @ObservationIgnored var currentActivity: Activity<LiveTrainsAttributes>?
    @ObservationIgnored private var cancellables: [AnyCancellable] = []
    @ObservationIgnored private var isLoading = false
    
    var id: ObjectIdentifier {
        trip.id
    }

    init(trip: Trip) {
        self.trip = trip
        guard trip.id != "11" else { return }
        
        retrieveTrip()
        
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, !self.isLoading else { return }
                // In the 10 minutes before a train is to arrive, refresh the data and make sure that it is not coming early or cancelled
                guard (self.tripTimes.first?.startTime ?? Date.distantPast).addingTimeInterval(-60 * 10) < Date.now else { return }
                self.retrieveTrip()
            }
            .store(in: &cancellables)
    }
    
    func setTripTimes(tripResponse: TripRequestResponse) {
        guard let journeys = tripResponse.journeys else {
            return
        }
        tripTimes = journeys.compactMap { journey in
            return journey.tripTime
        }
    }
    
    func retrieveTrip() {
        self.isLoading = true
        Task {
            do {
                var tripResponse = try await self.retreiveTripDetails()
                // If the element is of a time that has past, get rid of it as it is not needed
                // This is to safeguard against dogshit data
                let journeys = Array(tripResponse.journeys?.drop(while: { journey in
                    journey.firstArrivalTimeEstimatedDate < Date.now
                }) ?? [])
                
                tripResponse.journeys = journeys
                TrainLogger.stops.debug("Network Request made. Departure time: \(tripResponse.firstDepartureTimeEstimatedString )")
                
                self.setTripTimes(tripResponse: tripResponse)
                TrainLogger.stops.debug("Setting triptimes. \(self.tripTimes.debugDescription )")
                
                self.tripError = ""
            } catch {
                self.tripError = "Error: \(error)"
            }
            self.isLoading = false
        }
    }

    func retreiveTripDetails() async throws -> TripRequestResponse {
        let urlRequest = try TripPlannerManager.shared.getTripURLRequest(originStopId: trip.startStop.stopId, destinationStopId: trip.endStop.stopId)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(urlRequest).validate().responseDecodable(of: TripRequestResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.error != nil {
                        TrainLogger.network.error("data error")
                        continuation.resume(with: .failure(Errors.dataError))
                    } else if data.journeys == nil {
                        TrainLogger.network.error("no journeys")
                        continuation.resume(with: .failure(Errors.noJourney))
                    } else {
                        continuation.resume(with: .success(data))
                    }
                case .failure(let error):
                    TrainLogger.network.debug("\(error)")
                    continuation.resume(with: .failure(error))
                }
            }
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
