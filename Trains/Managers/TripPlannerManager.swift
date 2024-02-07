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

    func getTripURLRequest(destinationStopId: String = "10101100") throws -> URLRequest {
        guard let url = URL(string: "https://api.transport.nsw.gov.au/v1/tp/trip") else {
            Logger.network.error("Invalid URL")
            throw Errors.urlNotFound
        }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue("apikey eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJ5dlh2TVlLQTBUcUVyR1lRYUNqUmxOYjk0Q2k1WWZiQjVwT3ZUNWZfTmxZIiwiaWF0IjoxNzA2NjAxNTEwfQ.cKhJCMKX-9Se_AtMIaBqLmZfsyeaYrdslQm-0DxnsR0", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let queryParameters = [
            Foundation.URLQueryItem(name: "outputFormat", value: "rapidJSON"),
            Foundation.URLQueryItem(name: "coordOutputFormat", value: "EPSG 3A4326"),
            Foundation.URLQueryItem(name: "depArrMacro", value: "dep"),
            Foundation.URLQueryItem(name: "type_origin", value: "any"),
            Foundation.URLQueryItem(name: "name_origin", value: "207310"),
            Foundation.URLQueryItem(name: "type_destination", value: "any"),
            Foundation.URLQueryItem(name: "name_destination", value: destinationStopId),
            Foundation.URLQueryItem(name: "calcNumberOfTrips", value: "6" ),
            Foundation.URLQueryItem(name: "excludedMeans", value: "checkbox"),
            Foundation.URLQueryItem(name: "exclMOT_9", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_11", value: "1"),
            Foundation.URLQueryItem(name: "TfNSWTR", value: "true"),
            Foundation.URLQueryItem(name: "version", value: "10.2.1"),
            Foundation.URLQueryItem(name: "itOptionsActive", value: "0")
        ]
        request.url?.append(queryItems: queryParameters)
        print(request)
        return request
    }
}
