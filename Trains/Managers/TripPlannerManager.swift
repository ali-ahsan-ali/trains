//
//  TripPlannerManager.swift
//  Trains
//
//  Created by Ali, Ali on 11/8/2023.
//

import Foundation
import OSLog
import Alamofire

final class TripPlannerManager: Sendable {

    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }()
    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        return dateFormatter
    }()

    static private func getTripURLRequest(startStopId: String = "207310", endStopId: String = "10101100") throws -> URLRequest {
        guard let url = URL(string: "https://api.transport.nsw.gov.au/v1/tp/trip") else {
            TrainLogger.network.error("Invalid URL")
            throw Errors.urlNotFound
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue("apikey SOMETHINGDQ1fQ.VZ0HtvktBwflHGGkmp4WUkGfRW8XfnF439wmPjcq_Oc", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let queryParameters = [
            Foundation.URLQueryItem(name: "outputFormat", value: "rapidJSON"),
            Foundation.URLQueryItem(name: "coordOutputFormat", value: "EPSG:4326"),
            Foundation.URLQueryItem(name: "depArrMacro", value: "dep"),
            Foundation.URLQueryItem(name: "itdDate", value: "\(TripPlannerManager.formatter.string(from: Date.now))"),
            Foundation.URLQueryItem(name: "itdTime", value: "\(TripPlannerManager.timeFormatter.string(from: Date.now))"),
            Foundation.URLQueryItem(name: "type_origin", value: "any"),
            Foundation.URLQueryItem(name: "name_origin", value: startStopId),
            Foundation.URLQueryItem(name: "type_destination", value: "any"),
            Foundation.URLQueryItem(name: "name_destination", value: endStopId),
            Foundation.URLQueryItem(name: "calcNumberOfTrips", value: "10" ),
            Foundation.URLQueryItem(name: "excludedMeans", value: "checkbox"),
            Foundation.URLQueryItem(name: "exclMOT_4", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_5", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_7", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_9", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_11", value: "1"),
            Foundation.URLQueryItem(name: "TfNSWTR", value: "true"),
            Foundation.URLQueryItem(name: "itOptionsActive", value: "0"),
            Foundation.URLQueryItem(name: "computeMonomodalTripBicycle", value: "false"),
            Foundation.URLQueryItem(name: "cycleSpeed", value: "10"),
            Foundation.URLQueryItem(name: "version", value: "10.2.1.42")
        ]
        request.url?.append(queryItems: queryParameters)
        TrainLogger.network.debug("Request: \(request.description)")
        return request
    }
    
    static func retreiveTripTimes(startStopId: String, endStopId: String) async throws -> [TripTime] {
        let urlRequest = try getTripURLRequest(startStopId: startStopId, endStopId: endStopId)
        var response: TripRequestResponse = try await withCheckedThrowingContinuation { continuation in
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
        
        // Filter out bad responses from the API
        let journeys = Array(response.journeys?.drop(while: { journey in
            journey.firstArrivalTimeEstimatedDate < Date.now
        }) ?? [])
        response.journeys = journeys
        TrainLogger.stops.debug("Network Request made. Departure time: \(response.firstDepartureTimeEstimatedString )")

        // Print some response
        let enc = JSONEncoder()
        enc.outputFormatting = .prettyPrinted
        let json = try! enc.encode(response.tripTimes) // swiftlint:disable:this force_try
        TrainLogger.stops.debug("\(String(data: json, encoding: .utf8)!)") // swiftlint:disable:this force_unwrapping
       
        return response.tripTimes
    }
}
