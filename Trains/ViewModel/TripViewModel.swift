//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import GTFS
import Alamofire

class TripViewModel: ObservableObject {
    func retreiveTripDetails() async throws -> TripRequestResponse {
        let urlRequest = try TripPlannerManager.shared.getTripURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                
                if let error = error {
                    continuation.resume(with: .failure(error))
                    return
                }
                
                guard let data else {
                    continuation.resume(with: .failure(Errors.urlNotFound))
                    return
                }
                
                do {
                    // Parse the JSON data
                    let result = try JSONDecoder().decode(TripRequestResponse.self, from: data)
                    print(result.journeys?.first?.legs?.first?.origin?.departureTimeEstimated as Any)
                    continuation.resume(with: .success(result))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }.resume()
        }
    }
}
