//
//  Stopmanager.swift
//  Trains
//
//  Created by Ali Ali on 10/2/2024.
//

import Foundation

struct StopManager {
    
    static func retreiveStations() throws -> [String: [Stop]] {
        if let url = Bundle.main.url(forResource: "stops", withExtension: "json") {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([String: [Stop]].self, from: jsonData)
        } else {
            return try setupStations()
        }
    }
    
    static private func setupStations() throws -> [String: [Stop]] {
        var stations: [String: [Stop]] = [:]
        // swiftlint:disable:next force_unwrapping
        var stops: [Stop] = try initializeStops(Bundle.main.url(forResource: "stops", withExtension: "txt")!)
        stops = stops.filter { stop in
            return stop.locationType == .station
        }
        
        stops.sort { $0.stopName < $1.stopName }
        stations = Dictionary(grouping: stops, by: {
            let normalizedName = $0.stopName.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            let firstChar = String(normalizedName.first ?? "z").uppercased()
            return firstChar
        })
        if let encodedData = try? JSONEncoder().encode(stations) {
            let pathAsURL = Bundle.main.bundleURL.appending(path: "stops.json")
            try encodedData.write(to: pathAsURL)
        }
        return stations
    }
    
    static func initializeStops(_ path: URL) throws -> [Stop] {
        let reader = try CSVReader(path: path)
        
        return reader.map { line -> Stop in
            Stop(line: line)
        }
    }
}
