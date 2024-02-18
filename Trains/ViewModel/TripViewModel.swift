//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Alamofire
import Combine

@Observable
final class TripViewModel: Equatable, Hashable, Sendable, Identifiable {
    let trip: Trip
    private(set) var tripError: String?
    private(set) var tripResponse: TripRequestResponse?
    
    @ObservationIgnored private var cancellables = [AnyCancellable]()
    @ObservationIgnored private var isLoading = false
    var id: ObjectIdentifier{
        trip.id
    }

    init(trip: Trip) {
        self.trip = trip
        retrieveTrip()
        
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, !self.isLoading else { return }
                // In the 5 minutes before a train is to arrive, refresh the data and make sure that it is not coming early
                guard (self.tripResponse?.firstDepartureTimeEstimated ?? Date.now).addingTimeInterval(-60 * 5) < Date.now else { return }
                self.retrieveTrip()
            }
            .store(in: &cancellables)
    }
    
    
    func retrieveTrip() {
        self.isLoading = true
        Task {
            do {
                self.tripResponse = try await self.retreiveTripDetails()
                // If the first element is of a time that has past, get rid of it as it is not needed
                // This is to safeguard against dogshit data
                let journeys = Array(self.tripResponse?.journeys?.drop(while: { journey in
                    journey.firstArrivalTimeEstimatedDate < Date.now
                }) ?? [])
                self.tripResponse?.journeys = journeys
                
                TrainLogger.stops.debug("Network Request made. Departure time: \(self.tripResponse?.firstDepartureTimeEstimatedString ?? "Cannot find departure :(")")
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
