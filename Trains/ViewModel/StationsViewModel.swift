//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import Observation
import Apollo

@Observable
class StationListViewModel {
    var stops: [String: [Stop]] = [:]
    var alertMessage: String = ""
    var shouldShowAlert: Bool = false

    init () {
        Network.apolloClient.fetch(query: StationsQuery(), cachePolicy: .returnCacheDataElseFetch) { [weak self] result in
            guard let self else { return }
            var stops: [Stop] = []

            guard let data = try? result.get().data else {
                self.shouldShowAlert = true
                self.alertMessage = "There was an issue retrieving the list of stations"
                TrainLogger.stops.error("There was an issue retrieving the list of stations. No Data")
                return
            }
            stops = data.stations?.compactMap { station in
                guard let station else { return nil }
                return Stop(stopId: station.id, gtfsId: station.gtfsId, stopName: station.name.lowercased().replacingOccurrences(of: "Station", with: "").capitalized)
            } ?? []
            
            stops.sort { $0.stopName < $1.stopName }
            self.stops = Dictionary(grouping: stops, by: {
                let normalizedName = $0.stopName.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                let firstChar = String(normalizedName.first ?? "z").uppercased()
                return firstChar
            })
            
            if self.stops.isEmpty {
                self.shouldShowAlert = true
                self.alertMessage = "There was an issue retrieving the list of stations"
                TrainLogger.stops.error("There was an issue retrieving the list of stations.")
            } else {
                self.shouldShowAlert = false
            }
        }
    }
}
