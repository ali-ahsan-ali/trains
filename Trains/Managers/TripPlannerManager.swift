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

    func getTripURLRequest(destinationStopId: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.transport.nsw.gov.au/v1/tp/trip") else {
            Logger.network.error("Invalid URL")
            throw Errors.urlNotFound
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.string(from: DateManager.shared())
        dateFormatter.dateFormat = "HHmm"
        let time = dateFormatter.string(from: DateManager.shared())
        let locationManager = LocationManager().manager
//        let longitude = String(describing: locationManager.location?.coordinate.longitude)
//        let latitude = String(describing: locationManager.location?.coordinate.latitude)

        let latitude = -33.744674941769304
        let longitude = 151.14196308212118

        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.setValue("apikey 7gJ5ClWmlCngb7nmj4jnZRlhXCYjj8nDmeAg", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let queryParameters = [
            Foundation.URLQueryItem(name: "outputFormat", value: "rapidJSON"),
            Foundation.URLQueryItem(name: "coordOutputFormat", value: "EPSG 3A4326"),
            Foundation.URLQueryItem(name: "depArrMacro", value: "dep"),
            Foundation.URLQueryItem(name: "itdDate", value: date),
            Foundation.URLQueryItem(name: "itdtime", value: time),
            Foundation.URLQueryItem(name: "type_origin", value: "coord"),
            Foundation.URLQueryItem(name: "name_origin", value: "\(longitude):\(latitude):EPSG:4326"),
            Foundation.URLQueryItem(name: "type_destination", value: "any"),
            Foundation.URLQueryItem(name: "name_destination", value: destinationStopId),
            Foundation.URLQueryItem(name: "calcNumberOfTrips", value: "6" ),
            Foundation.URLQueryItem(name: "excludedMeans", value: "checkbox"),
            Foundation.URLQueryItem(name: "exclMOT_4", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_5", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_7", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_9", value: "1"),
            Foundation.URLQueryItem(name: "exclMOT_11", value: "1"),
            Foundation.URLQueryItem(name: "TfNSWTR", value: "true"),
            Foundation.URLQueryItem(name: "version", value: "10.2.1")
        ]
        request.url?.append(queryItems: queryParameters)
        print(request)
        return request

//    https://api.transport.nsw.gov.au/v1/tp/trip?outputFormat=rapidJSON&coordOutputFormat=EPSG%203A4326&depArrMacro=dep&itdDate=20230815&itdtime=1553&type_origin=coord&name_origin=-33.744674941769304:151.14196308212118:EPSG:4326&type_destination=any&name_destination=200060&calcNumberOfTrips=6&excludedMeans=checkbox&exclMOT_4=1&exclMOT_5=1&exclMOT_7=1&exclMOT_9=1&exclMOT_11=1&TfNSWTR=true&version=10.2.1
    }
}
