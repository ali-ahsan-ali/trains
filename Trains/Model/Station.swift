//
//  Station.swift
//  Trains
//
//  Created by Ali, Ali on 5/8/2023.
//

import Foundation

struct Station: Identifiable, Codable {
    let id = UUID()
    let name: String
    let lon: Double?
    let lat: Double?

    init(name: String, lon: Double? = nil, lat: Double? = nil) {
        self.name = name
        self.lon = lon
        self.lat = lat
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case lon
        case lat
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Station.CodingKeys> = try decoder.container(keyedBy: Station.CodingKeys.self)
        self.name = try container.decode(String.self, forKey: Station.CodingKeys.name)
        self.lon = try container.decodeIfPresent(Double.self, forKey: Station.CodingKeys.lon)
        self.lat = try container.decodeIfPresent(Double.self, forKey: Station.CodingKeys.lat)
    }

    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Station.CodingKeys> = encoder.container(keyedBy: Station.CodingKeys.self)

        try container.encode(self.id, forKey: Station.CodingKeys.id)
        try container.encode(self.name, forKey: Station.CodingKeys.name)
        try container.encodeIfPresent(self.lon, forKey: Station.CodingKeys.lon)
        try container.encodeIfPresent(self.lat, forKey: Station.CodingKeys.lat)
    }
}


//{
//        "id": "U3RvcDoxOjIwNzMxMA",
//        "name": "Pymble Station",
//        "lat": -33.7447289,
//        "lon": 151.142138
//      },
//
//
//{
//  "id": "U3RvcDoxOjIwMTUxMA",
//  "name": "Redfern Station",
//  "lat": -33.8923699,
//  "lon": 151.1984847
//},

//org.opentripplanner.ext.legacygraphqlapi.datafetchers.LegacyGraphQLPlaceImpl.getSource(graphql.schema.DataFetchingEnvironment).arrival
