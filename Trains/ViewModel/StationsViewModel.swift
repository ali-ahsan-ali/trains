//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Observation

@Observable
class StationListViewModel {
    var stops: [String: [Stop]]
    var alertMessage: String = ""
    var shouldShowAlert: Bool

    init() {
        do {
            stops = try StopManager.retreiveStations()
            shouldShowAlert = false
        } catch {
            shouldShowAlert = true
            alertMessage = "There was an issue retrieving the list of stations"
            stops = [:]
            TrainLogger.stops.error("There was an issue retrieving the list of stations. Error: \(error)")
        }
    }
}
