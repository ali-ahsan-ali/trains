//
//  Stop.swift
//  Trains
//
//  Created by Ali Ali on 10/2/2024.
//

import SwiftUI
import SwiftData

@Model
public final class Stop: Codable, FromCSVLine, Equatable, Hashable, Sendable {
  
    public var stopId: String
//    public var stopCode: String?
    public var stopName: String
//    public var stopDesc: String?
//    public var stopLat: Double?
//    public var stopLon: Double?
//    public var zoneId: String?
//    public var stopUrl: String?
    public var locationType: LocationType?
//    public var parentStation: String?
//    public var stopTimezone: String?
//    public var wheelchairBoarding: WheelchairAccessible?
//    public var levelId: String?
//    public var platformCode: String?
    
    public init(line: CSVLine) {
        stopId = line["stop_id"]! // swiftlint:disable:this force_unwrapping
//        stopCode = line["stop_code"]
        stopName = line["stop_name"] ?? "No Stop Name :("
//        stopDesc = line["stop_desc"]
//        stopLat = Double.from(line["stop_lat"])
//        stopLon = Double.from(line["stop_lon"])
//        zoneId = line["zone_id"]
//        stopUrl = line["stop_url"]
        locationType = LocationType.from(line["location_type"])
//        parentStation = line["parent_station"]
//        stopTimezone = line["stop_timezone"]
//        wheelchairBoarding = WheelchairAccessible.from(line["wheelchair_boarding"])
//        levelId = line["level_id"]
//        platformCode = line["platform_code"]
    }
    
    public init(stopId: String, stopCode: String? = nil, stopName: String, stopDesc: String? = nil, stopLat: Double? = nil, stopLon: Double? = nil, zoneId: String? = nil, stopUrl: String? = nil, locationType: LocationType? = nil, parentStation: String? = nil, stopTimezone: String? = nil, wheelchairBoarding: WheelchairAccessible? = nil, levelId: String? = nil, platformCode: String? = nil) {
        self.stopId = stopId
//        self.stopCode = stopCode
        self.stopName = stopName
//        self.stopDesc = stopDesc
//        self.stopLat = stopLat
//        self.stopLon = stopLon
//        self.zoneId = zoneId
//        self.stopUrl = stopUrl
        self.locationType = locationType
//        self.parentStation = parentStation
//        self.stopTimezone = stopTimezone
//        self.wheelchairBoarding = wheelchairBoarding
//        self.levelId = levelId
//        self.platformCode = platformCode
    }
    
    public var stopNameWithoutStation: String {
        stopName.lowercased().replacingOccurrences(of: "station", with: "").capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case stopId
        case stopCode
        case stopName
        case stopDesc
        case stopLat
        case stopLon
        case zoneId
        case stopUrl
        case locationType
        case parentStation
        case stopTimezone
        case wheelchairBoarding
        case levelId
        case platformCode
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stopId, forKey: .stopId)
//        try container.encode(stopCode, forKey: .stopCode)
        try container.encode(stopName, forKey: .stopName)
//        try container.encode(stopDesc, forKey: .stopDesc)
//        try container.encode(stopLat, forKey: .stopLat)
//        try container.encode(stopLon, forKey: .stopLon)
//        try container.encode(zoneId, forKey: .zoneId)
//        try container.encode(stopUrl, forKey: .stopUrl)
        try container.encode(locationType, forKey: .locationType)
//        try container.encode(parentStation, forKey: .parentStation)
//        try container.encode(stopTimezone, forKey: .stopTimezone)
//        try container.encode(wheelchairBoarding, forKey: .wheelchairBoarding)
//        try container.encode(levelId, forKey: .levelId)
//        try container.encode(platformCode, forKey: .platformCode)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stopId = try values.decode(String.self, forKey: .stopId)
//        stopCode = try values.decodeIfPresent(String.self, forKey: .stopCode)
        stopName = try values.decode(String.self, forKey: .stopName)
//        stopDesc = try values.decodeIfPresent(String.self, forKey: .stopDesc)
//        stopLat = try values.decodeIfPresent(Double.self, forKey: .stopLat)
//        stopLon = try values.decodeIfPresent(Double.self, forKey: .stopLon)
//        zoneId = try values.decodeIfPresent(String.self, forKey: .zoneId)
//        stopUrl = try values.decodeIfPresent(String.self, forKey: .stopUrl)
        locationType = try values.decodeIfPresent(LocationType.self, forKey: .locationType)
//        parentStation = try values.decodeIfPresent(String.self, forKey: .parentStation)
//        stopTimezone = try values.decodeIfPresent(String.self, forKey: .stopTimezone)
//        wheelchairBoarding = try values.decodeIfPresent(WheelchairAccessible.self, forKey: .wheelchairBoarding)
//        levelId = try values.decodeIfPresent(String.self, forKey: .levelId)
//        platformCode = try values.decodeIfPresent(String.self, forKey: .platformCode)
    }
    
    public static func == (lhs: Stop, rhs: Stop) -> Bool {
        lhs.stopId == rhs.stopId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stopId)
    }
}

public enum LocationType: Int, Codable {
    case stop = 0
    case station = 1
    case entranceOrExit = 2
    case genericNode = 3
    case boardingArea = 4
    
    static func from(_ string: String?) -> LocationType? {
        if let string = string {
            if let int = Int(string) {
                return LocationType(rawValue: int) ?? .stop
            } else {
                return .stop
            }
        } else {
            return nil
        }
    }
}

public enum WheelchairAccessible: Int, Codable {
    case noInformation = 0
    case wheelchairAccessible = 1
    case notWheelchairAccessible = 2
    
    static func from(_ string: String?) -> WheelchairAccessible? {
        if let string = string {
            if let int = Int(string) {
                return WheelchairAccessible(rawValue: int) ?? .noInformation
            } else {
                return .noInformation
            }
        } else {
            return nil
        }
    }
}
