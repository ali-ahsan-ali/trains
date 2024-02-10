//
//  Stop.swift
//  Trains
//
//  Created by Ali Ali on 10/2/2024.
//

import Foundation

public struct Stop: Codable, FromCSVLine, Identifiable, Equatable {
    public var id = UUID()
    public let stopId: String
    public let stopCode: String?
    public let stopName: String
    public let stopDesc: String?
    public let stopLat: Double?
    public let stopLon: Double?
    public let zoneId: String?
    public let stopUrl: String?
    public let locationType: LocationType?
    public let parentStation: String?
    public let stopTimezone: String?
    public let wheelchairBoarding: WheelchairAccessible?
    public let levelId: String?
    public let platformCode: String?

    public init(line: CSVLine) {
        stopId = line["stop_id"]! // swiftlint:disable:this force_unwrapping
        stopCode = line["stop_code"]
        stopName = line["stop_name"] ?? ""
        stopDesc = line["stop_desc"]
        stopLat = Double.from(line["stop_lat"])
        stopLon = Double.from(line["stop_lon"])
        zoneId = line["zone_id"]
        stopUrl = line["stop_url"]
        locationType = LocationType.from(line["location_type"])
        parentStation = line["parent_station"]
        stopTimezone = line["stop_timezone"]
        wheelchairBoarding = WheelchairAccessible.from(line["wheelchair_boarding"])
        levelId = line["level_id"]
        platformCode = line["platform_code"]
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


