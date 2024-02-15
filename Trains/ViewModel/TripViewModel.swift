//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Alamofire
import Observation
import SwiftData

@Model
final class TripViewModel {
    @Attribute(.unique) var id: String
    var startStop: Stop
    var endStop: Stop
    var created: Date
    @Attribute(.ephemeral) var tripError: String?
    @Attribute(.ephemeral) var trips: TripRequestResponse?

    init(startStop: Stop, endStop: Stop, created: Date = Date.now) {
        self.startStop = startStop
        self.endStop = endStop
        self.created = created
        self.id = startStop.stopId + endStop.stopId
    }

    func retreiveTripDetails() async throws -> TripRequestResponse {
        let urlRequest = try TripPlannerManager.shared.getTripURLRequest(originStopId: startStop.stopId, destinationStopId: endStop.stopId)
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
                        TrainLogger.stops.debug("Network Request made. Departure time: \(data.journeys?.first?.legs?.first?.origin?.departureTimeEstimated ?? "")")
                        continuation.resume(with: .success(data))
                    }
                case .failure(let error):
                    TrainLogger.network.debug("\(error)")
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}
