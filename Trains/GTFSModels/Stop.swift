//
// Stop.swift
//

import Foundation
import CoreLocation

// MARK: StopField

/// Describes the various fields found within a ``Stop`` record or header.
///
/// `StopField`s are generally members of `Set`s that enumerate
/// the fields found within a ``Stop`` record or header. The following,
/// for example, returns the `Set` of route fields found within
/// the `myStops` feed header:
/// ```swift
///   let fields = myStops.headerFields
/// ```
///
/// Should you need it, use `rawValue` to obtain the GTFS stop field name
/// associated with an `StopField` value as a `String`:
/// ```swift
///   let gtfsField = RouteField.details.rawValue  //  Returns "route_desc"
/// ```
public enum StopField: String, Hashable, KeyPathVending, Codable{
    /// Stop ID field.
    case stopID = "stop_id"
    /// Stop code field.
    case code = "stop_code"
    /// Stop name field.
    case name = "stop_name"
    /// Stop details field.
    case details = "stop_desc"
    /// Stop latitude field.
    case latitude = "stop_lat"
    /// Stop longitude field.
    case longitude = "stop_lon"
    /// Stop zone ID field.
    case zoneID = "zone_id"
    /// Stop URL field.
    case url = "stop_url"
    /// Stop location type field.
    case locationType = "location_type"
    /// Stop parent station ID field.
    case parentStationID = "parent_station"
    /// Stop timezone field.
    case timeZone = "stop_timezone"
    /// Stop accessibility field.
    case accessibility = "wheelchair_boarding"
    /// Stop level ID field.
    case levelID = "level_id"
    /// Stop platform code field.
    case platformCode = "platform_code"
    /// Used when a nonstandard field is found within a GTFS feed.
    case nonstandard = "nonstandard"
    
    internal var path: AnyKeyPath {
        switch self {
        case .stopID: return \Stop.stopID
        case .code: return \Stop.code
        case .name: return \Stop.name
        case .details: return \Stop.details
        case .latitude: return \Stop.latitude
        case .longitude: return \Stop.longitude
        case .zoneID: return \Stop.zoneID
        case .url: return \Stop.url
        case .locationType: return \Stop.locationType
        case .parentStationID: return \Stop.parentStationID
        case .timeZone: return \Stop.timeZone
        case .accessibility: return \Stop.accessibility
        case .levelID: return \Stop.levelID
        case .platformCode: return \Stop.platformCode
        case .nonstandard: return \Stop.nonstandard
        }
    }
}

/// - Tag: StopCode
public typealias StopCode = String

/// - Tag: StopLocationType
public enum StopLocationType: UInt, Hashable, Codable{
    case stopOrPlatform = 0
    case station = 1
    case entranceOrExit = 2
    case genericNode = 3
    case boardingArea = 4
}

/// - Tag: Accessibility
public enum Accessibility: UInt, Hashable, Codable{
    case unknownOrInherits = 0
    case partialOrFull = 1
    case none = 2
}

/// A representation of a single Stop record.
public class Stop: Hashable, Identifiable, Codable{
   
    public let id = UUID()
    public var stopID: TransitID = ""
    public var code: StopCode?
    public var name: String?
    public var details: String?
    public var latitude: CLLocationDegrees?
    public var longitude: CLLocationDegrees?
    public var zoneID: TransitID?
    public var url: URL?
    public var locationType: StopLocationType?
    public var parentStationID: TransitID?
    public var timeZone: TimeZone?
    public var accessibility: Accessibility?
    public var levelID: TransitID?
    public var platformCode: String?
    public var childStops: [Stop] = []
    public var nonstandard: String? = nil
    public var stopTimes: [StopTime] = []
    
    public init(
        stopID: TransitID = "Unidentified stop",
        code: StopCode? = nil,
        name: String? = nil,
        details: String? = nil,
        latitude: CLLocationDegrees? = nil,
        longitude: CLLocationDegrees? = nil,
        zoneID: TransitID? = nil,
        url: URL? = nil,
        locationType: StopLocationType? = nil,
        parentStationID: TransitID? = nil,
        timeZone: TimeZone? = nil,
        accessibility: Accessibility? = nil,
        levelID: TransitID? = nil,
        childStops: [Stop] = [],
        stopTimes: [StopTime] = [],
        platformCode: String? = nil
    ) {
        self.stopID = stopID
        self.code = code
        self.name = name
        self.details = details
        self.latitude = latitude
        self.longitude = longitude
        self.zoneID = zoneID
        self.url = url
        self.locationType = locationType
        self.parentStationID = parentStationID
        self.timeZone = timeZone
        self.accessibility = accessibility
        self.levelID = levelID
        self.childStops = childStops
        self.stopTimes = stopTimes
        self.platformCode = platformCode
    }
    
    public static let requiredFields: Set =
    [StopField.stopID]
    
    init(from record: String, using headers: [StopField]) throws {
        do {
            let fields = try record.readRecord()
            if fields.count != headers.count {
                throw TransitError.headerRecordMismatch
            }
            for (index, header) in headers.enumerated() {
                let field = fields[index]
                switch header {
                    case .stopID:
                        self.stopID = field
                    case .code:
                        self.code = field
                    case .name:
                        self.name = field
                    case .details:
                        self.details = field
                    case .zoneID:
                        self.zoneID = field
                    case .parentStationID:
                        self.parentStationID = field.isEmpty ? nil : field
                    case .levelID:
                        self.levelID = field
                    case .platformCode:
                        self.platformCode = field
                    case .url:
                        continue
                    case .timeZone:
                        let timeZone = TimeZone(identifier: field)
                        self.timeZone = timeZone
                    case .latitude:
                        let latitude = Double(field)
                        self.latitude = latitude
                    case .longitude:
                        let longitude = Double(field)
                        self.longitude = longitude
                    // Add cases for other headers
                    case .nonstandard:
                        continue
                    case .locationType:
                        continue
                    case .accessibility:
                        continue
                    }
                }
        } catch let error {
            throw error
        }
    }
    
    public static func stopLocationTypeFrom(string: String)
    -> StopLocationType? {
        if let rawValue = UInt(string) {
            return StopLocationType(rawValue: rawValue)
        } else {
            return nil
        }
    }
    
    public static func accessibilityFrom(string: String) -> Accessibility? {
        if let rawValue = UInt(string) {
            return Accessibility(rawValue: rawValue)
        } else {
            return nil
        }
    }
    
    private static let requiredHeaders: Set =
    [StopField.stopID]
    
    enum CodingKeys: CodingKey {
        case id
        case stopID
        case code
        case name
        case details
        case latitude
        case longitude
        case zoneID
        case url
        case locationType
        case parentStationID
        case timeZone
        case accessibility
        case levelID
        case platformCode
        case childStops
        case nonstandard
        case stopTimes
    }
    
    required public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Stop.CodingKeys> = try decoder.container(keyedBy: Stop.CodingKeys.self)
        
        self.stopID = try container.decode(TransitID.self, forKey: Stop.CodingKeys.stopID)
        self.code = try container.decodeIfPresent(StopCode.self, forKey: Stop.CodingKeys.code)
        self.name = try container.decodeIfPresent(String.self, forKey: Stop.CodingKeys.name)
        self.details = try container.decodeIfPresent(String.self, forKey: Stop.CodingKeys.details)
        self.latitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: Stop.CodingKeys.latitude)
        self.longitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: Stop.CodingKeys.longitude)
        self.zoneID = try container.decodeIfPresent(TransitID.self, forKey: Stop.CodingKeys.zoneID)
        self.url = try container.decodeIfPresent(URL.self, forKey: Stop.CodingKeys.url)
        self.locationType = try container.decodeIfPresent(StopLocationType.self, forKey: Stop.CodingKeys.locationType)
        self.parentStationID = try container.decodeIfPresent(TransitID.self, forKey: Stop.CodingKeys.parentStationID)
        self.timeZone = try container.decodeIfPresent(TimeZone.self, forKey: Stop.CodingKeys.timeZone)
        self.accessibility = try container.decodeIfPresent(Accessibility.self, forKey: Stop.CodingKeys.accessibility)
        self.levelID = try container.decodeIfPresent(TransitID.self, forKey: Stop.CodingKeys.levelID)
        self.platformCode = try container.decodeIfPresent(String.self, forKey: Stop.CodingKeys.platformCode)
        self.childStops = try container.decode([Stop].self, forKey: Stop.CodingKeys.childStops)
        self.nonstandard = try container.decodeIfPresent(String.self, forKey: Stop.CodingKeys.nonstandard)
        self.stopTimes = try container.decodeIfPresent([StopTime].self, forKey: Stop.CodingKeys.stopTimes) ?? []
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Stop.CodingKeys> = encoder.container(keyedBy: Stop.CodingKeys.self)
        
        try container.encode(self.id, forKey: Stop.CodingKeys.id)
        try container.encode(self.stopID, forKey: Stop.CodingKeys.stopID)
        try container.encodeIfPresent(self.code, forKey: Stop.CodingKeys.code)
        try container.encodeIfPresent(self.name, forKey: Stop.CodingKeys.name)
        try container.encodeIfPresent(self.details, forKey: Stop.CodingKeys.details)
        try container.encodeIfPresent(self.latitude, forKey: Stop.CodingKeys.latitude)
        try container.encodeIfPresent(self.longitude, forKey: Stop.CodingKeys.longitude)
        try container.encodeIfPresent(self.zoneID, forKey: Stop.CodingKeys.zoneID)
        try container.encodeIfPresent(self.url, forKey: Stop.CodingKeys.url)
        try container.encodeIfPresent(self.locationType, forKey: Stop.CodingKeys.locationType)
        try container.encodeIfPresent(self.parentStationID, forKey: Stop.CodingKeys.parentStationID)
        try container.encodeIfPresent(self.timeZone, forKey: Stop.CodingKeys.timeZone)
        try container.encodeIfPresent(self.accessibility, forKey: Stop.CodingKeys.accessibility)
        try container.encodeIfPresent(self.levelID, forKey: Stop.CodingKeys.levelID)
        try container.encodeIfPresent(self.platformCode, forKey: Stop.CodingKeys.platformCode)
        try container.encode(self.childStops, forKey: Stop.CodingKeys.childStops)
        try container.encodeIfPresent(self.nonstandard, forKey: Stop.CodingKeys.nonstandard)
        try container.encodeIfPresent(self.stopTimes, forKey: Stop.CodingKeys.stopTimes)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stopID)
    }
}

extension Stop: Equatable {
    public static func == (lhs: Stop, rhs: Stop) -> Bool {
        lhs.stopID == rhs.stopID
    }
}

extension Stop: CustomStringConvertible {
    public var description: String {
        return "Stop: \(self.stopID)"
    }
}

// MARK: - Stops

/// A representation of a complete Stops dataset.
public class Stops: Identifiable, Codable{
    public let id = UUID()
    public var headerFields = [StopField]()
    public var stops = [Stop]()
    
    subscript(index: Int) -> Stop {
        get {
            return stops[index]
        }
        set(newValue) {
            stops[index] = newValue
        }
    }
    
    init<S: Sequence>(_ sequence: S)
    where S.Iterator.Element == Stop {
        for stop in sequence {
            self.stops.append(stop)
        }
    }
    
    init(from url: URL) throws {
        do {
            let records = try String(contentsOf: url).splitRecords()
            
            if records.count <= 1 { return }
            let headerRecord = String(records[0])
            self.headerFields = try headerRecord.readHeader()
            
            self.stops.reserveCapacity(records.count - 1)
            for stopRecord in records[1 ..< records.count] {
                let stop = try Stop(from: String(stopRecord), using: headerFields)
                if stop.parentStationID == nil{
                    self.stops.append(stop)
                }else{
                    if let parentStop = self.stops.first(where: {$0.stopID == stop.parentStationID}){
                        parentStop.childStops.append(stop)
                    }
                }
            }
        } catch let error {
            throw error
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case headerFields
        case stops
    }
    
    required public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Stops.CodingKeys> = try decoder.container(keyedBy: Stops.CodingKeys.self)
        
        self.headerFields = try container.decode([StopField].self, forKey: Stops.CodingKeys.headerFields)
        self.stops = try container.decode([Stop].self, forKey: Stops.CodingKeys.stops)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Stops.CodingKeys.self)
        
        try container.encode(self.id, forKey: Stops.CodingKeys.id)
        try container.encode(self.headerFields, forKey: Stops.CodingKeys.headerFields)
        try container.encode(self.stops, forKey: Stops.CodingKeys.stops)
    }
}

extension Stops: Sequence {
    public typealias Iterator = IndexingIterator<[Stop]>
    
    public func makeIterator() -> Iterator {
        return stops.makeIterator()
    }
}
