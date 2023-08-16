//
//  StationsViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 28/7/2023.
//

import SwiftUI
import GTFS

class StationListViewModel: ObservableObject {
    @Published var stations: [String: [Stop]]
    @Published var appAlert: String?
    @Published var isError: Bool
    @Published var savedDestinationStations: [TripViewModel] = []
    private let cache: CacheManager

    init() {
        self.stations = [:]
        self.isError = false
        self.cache = CacheManager()
        self.savedDestinationStations = cache.getStationDestinations().map({ Stop in
            return TripViewModel(destination: Stop)
        })
    }

    func retreiveTripDetails(_ tripviewModel: TripViewModel) async {

    }

    func saveDestinationStations() {
        cache.saveStationDestinations(savedDestinationStations.map{ $0.destination })
    }

    func appendDestination(_ stop: Stop) {
        savedDestinationStations.append(TripViewModel(destination: stop))
    }

    func retreiveStations() {
        if !stations.isEmpty { return }
        do {
            if let url = Bundle.main.url(forResource: "stops", withExtension: "json") {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.stations = try decoder.decode([String: [Stop]].self, from: jsonData)
            } else {
                try setupStations()
            }
        } catch {
            isError = true
            appAlert = "Could not unwrap stops.txt"
        }
    }

    private func setupStations() throws {
        // swiftlint:disable:next force_unwrapping
        let stops = try initialiseStops(Bundle.main.url(forResource: "stops", withExtension: "txt")!)
        var stations = stops.filter { stop in
            stop.parentStation?.isEmpty ?? true
        }
        stations.sort(by: { $0.stopName < $1.stopName })
        self.stations = Dictionary(grouping: stations, by: {
            let normalizedName = $0.stopName.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            let firstChar = String(normalizedName.first ?? "z").uppercased()
            return firstChar
        })
        if let encodedData = try? JSONEncoder().encode(self.stations) {
            let pathAsURL = URL.temporaryDirectory.appending(path: "stops.json")
            try encodedData.write(to: pathAsURL)
        }
    }
}
