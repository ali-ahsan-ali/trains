//
//  TripPlannerManager.swift
//  Trains
//
//  Created by Ali, Ali on 11/8/2023.
//

import Foundation
import OSLog

class TripPlannerManager {

    static let shared = TripPlannerManager()

    func getTripURLRequest(originStopId: String = "207310", destinationStopId: String = "10101100", swap: Bool = false) throws -> URLRequest {
        guard let url = URL(string: "https://api.transport.nsw.gov.au/v1/tp/trip") else {
            TrainLogger.network.error("Invalid URL")
            throw Errors.urlNotFound
        }
        var origin = originStopId
        var destination = destinationStopId
        if swap {
            let temp = origin
            origin = destination
            destination = temp
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue("apikey eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJ5dlh2TVlLQTBUcUVyR1lRYUNqUmxOYjk0Q2k1WWZiQjVwT3ZUNWZfTmxZIiwiaWF0IjoxNzA2NjAxNTEwfQ.cKhJCMKX-9Se_AtMIaBqLmZfsyeaYrdslQm-0DxnsR0", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let queryParameters = [
            Foundation.URLQueryItem(name: "outputFormat", value: "rapidJSON"),
            Foundation.URLQueryItem(name: "coordOutputFormat", value: "EPSG 3A4326"),
            Foundation.URLQueryItem(name: "depArrMacro", value: "dep"),
            Foundation.URLQueryItem(name: "type_origin", value: "any"),
            Foundation.URLQueryItem(name: "name_origin", value: origin),
            Foundation.URLQueryItem(name: "type_destination", value: "any"),
            Foundation.URLQueryItem(name: "name_destination", value: destination),
            Foundation.URLQueryItem(name: "calcNumberOfTrips", value: "6" ),
            Foundation.URLQueryItem(name: "excludedMeans", value: "checkbox"),
            Foundation.URLQueryItem(name: "exclMOT_4", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_5", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_7", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_9", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_11", value: "1")
        ]
        request.url?.append(queryItems: queryParameters)
        return request
    }
}
