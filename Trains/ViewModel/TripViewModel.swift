//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Alamofire
import Observation
//import SwiftData

//@Model
class TripViewModel {
//    @Attribute(.unique)
    let id: UUID
    let startStop: Stop
    let endStop: Stop
    
    init(id: UUID = UUID(), startStop: Stop, endStop: Stop) {
        self.id = id
        self.startStop = startStop
        self.endStop = endStop
    }
    
    func retreiveTripDetails() async throws -> TripRequestResponse {
        let urlRequest = try TripPlannerManager.shared.getTripURLRequest()
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(urlRequest).validate().responseDecodable(of: TripRequestResponse.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(with: .success(data))
                case .failure(let error):
                    print(error)
                    continuation.resume(with: .failure(error))
                }
            }
        }

    }
}
