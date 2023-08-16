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
    init(appAlert: String? = "", isError: Bool = false, destination: Stop) {
        self.appAlert = appAlert
        self.isError = isError
        self.destination = destination
    }

    @Published var appAlert: String? = ""
    @Published var isError: Bool = false
    @State var destination: Stop
    @Published var state: APIState = .initial

    func retreiveTripDetails() {
        do {
            let urlRequest = try TripPlannerManager.shared.getTripURLRequest(destinationStopId: destination.stopId)
            Network.session.request(urlRequest)
                .responseDecodable(of: TripRequestResponse.self) { response in
                    print(Date())
                    print(response.error as Any)
                    if let error = response.value?.error {
                        print(error)
                    }
                    guard let result = response.value else {return}
                    print(result as Any)
                }
        } catch {
//            print(Date())
//            print(error)
        }

//        curl -X GET --header 'Accept: application/json' --header 'Authorization: apikey 7gJ5ClWmlCngb7nmj4jnZRlhXCYjj8nDmeAg' 'https://api.transport.nsw.gov.au/v1/tp/trip?outputFormat=rapidJSON&coordOutputFormat=EPSG%3A4326&depArrMacro=dep&itdDate=20230811&itdTime=1200&type_origin=coord&name_origin=151.14524487148276%3A-33.74760894575996%3AEPSG%3A4326&type_destination=any&name_destination=10101100&calcNumberOfTrips=6&excludedMeans=checkbox&exclMOT_4=1&exclMOT_5=1&exclMOT_7=1&exclMOT_9=1&exclMOT_11=1&TfNSWTR=true&version=10.2.1.42&itOptionsActive=1&cycleSpeed=16'

    }
}
