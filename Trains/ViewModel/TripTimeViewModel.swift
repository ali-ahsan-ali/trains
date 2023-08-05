//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import OpenTripPlannerApi
import SwiftUI

class StationListViewModel: ObservableObject {
    private let cache: CacheManager

    init() {
        self.stations = [:]
        self.isError = false
        self.cache = CacheManager()
        self.tripViewModels = self.cache.getTrips()
    }

    func saveTrips() {
        cache.saveTrips(tripViewModels)
    }

    func getTrips() {
        tripViewModels = cache.getTrips()
    }

    func addTrip(fromStop: StationListQuery.Data.Station, toStop: StationListQuery.Data.Station){
        tripViewModels.append(
            TripViewModel(
                fromStation: Station(
                    name: fromStop.name,
                    lon: fromStop.lon,
                    lat: fromStop.lat
                ),
                toStation: Station(
                    name: toStop.name,
                    lon: toStop.lon,
                    lat: toStop.lat
                )
            )
        )
    }

    func retreiveStations() {
        if !stations.isEmpty { return }

        Network.shared.apolloClient?.fetch(query: StationListQuery()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let stations = graphQLResult.data?.stations {
                    var filteredStations = stations.compactMap { $0 == nil ? nil : $0 }
                    filteredStations.sort { $0.name < $1.name }
                    self.stations = Dictionary(grouping: filteredStations, by: {
                        let name = $0.name
                        let normalizedName = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                        let firstChar = String(normalizedName.first ?? "z").uppercased()
                        return firstChar
                    })
                }
                if let errors = graphQLResult.errors {
                    self.appAlert = errors.debugDescription
                    self.isError = true
                }
            case .failure(let error):
                self.appAlert = error.localizedDescription
                self.isError = true
            }
        }
    }
}
