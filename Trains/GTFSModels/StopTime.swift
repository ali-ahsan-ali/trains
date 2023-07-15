//
// StopTime.swift
//

import Foundation

// MARK: StopTimeField

/// Describes the various fields found within a ``Route`` record or header.
///
/// `StopTimeField`s are generally members of `Set`s that enumerate
/// the fields found within a ``StopTime`` record or header. The following,
/// for example, returns the `Set` of route fields found within
/// the `myStopTimes` feed header:
/// ```swift
///   let fields = myStopTimes.headerFields
/// ```
///
/// Should you need it, use `rawValue` to obtain the GTFS stop time field name
/// associated with an `StopTimeField` value as a `String`:
/// ```swift
///   let gtfsField = StopTimeField.details.rawValue  //  Returns "route_desc"
/// ```
public enum StopTimeField: String, Hashable, KeyPathVending, Codable {
    /// Trip ID field.
    case tripID = "trip_id"
    /// Trip arrival field.
    case arrival = "arrival_time"
    /// Trip departure field.
    case departure = "departure_time"
    /// Stop ID field.
    case stopID = "stop_id"
    /// Stop sequence number field.
    case stopSequenceNumber = "stop_sequence"
    /// Stop heading sign field.
    case stopHeadingSign = "stop_headsign"
    /// Stop pickup type field.
    case pickupType = "pickup_type"
    /// Stop drop off type field.
    case dropOffType = "drop_off_type"
    /// Stop continuous pickup field.
    case continuousPickup = "continuous_pickup"
    /// Stop continuous drop off field.
    case continuousDropOff = "continuous_drop_off"
    /// Stop distance traveled for shape field.
    case distanceTraveledForShape = "shape_dist_traveled"
    /// Stop time point type field.
    case timePointType = "timepoint"
    /// Used when a nonstandard field is found within a GTFS feed.
    case nonstandard = "nonstandard"
    
    internal var path: AnyKeyPath {
        switch self {
        case .tripID: return \StopTime.tripID
        case .arrival: return \StopTime.arrival
        case .departure: return \StopTime.departure
        case .stopID: return \StopTime.stopID
        case .stopSequenceNumber: return \StopTime.stopSequenceNumber
        case .stopHeadingSign: return \StopTime.stopHeadingSign
        case .pickupType: return \StopTime.pickupType
        case .dropOffType: return \StopTime.dropOffType
        case .continuousPickup: return \StopTime.continuousPickup
        case .continuousDropOff: return \StopTime.continuousDropOff
        case .distanceTraveledForShape: return \StopTime.distanceTraveledForShape
        case .timePointType: return \StopTime.timePointType
        case .nonstandard: return \StopTime.nonstandard
        }
    }
}

// MARK: - StopTime

/// A representation of a single StopTime record.
public struct StopTime: Hashable, Identifiable, Codable {
    public var id = UUID()
    public var tripID: TransitID = ""
    public var arrival: DateComponents?
    public var departure: DateComponents?
    public var stopID: TransitID = ""
    public var stopSequenceNumber: UInt = 0
    public var stopHeadingSign: String?
    public var pickupType: Int?
    public var dropOffType: Int?
    public var continuousPickup: Int?
    public var continuousDropOff: Int?
    public var distanceTraveledForShape: Double?
    public var timePointType: Int?
    public var nonstandard: String? = nil
    public var startDate: Date? = nil
    public var endDate: Date? = nil

    
    public init(
        tripID: TransitID = "",
        arrival: DateComponents? = nil,
        departure: DateComponents? = nil,
        stopID: TransitID = "",
        stopSequenceNumber: UInt = 0,
        stopHeadingSign: String? = nil,
        pickupType: Int? = nil,
        dropOffType: Int? = nil,
        continuousPickup: Int? = nil,
        continuousDropOff: Int? = nil,
        distanceTraveledForShape: Double? = nil,
        timePointType: Int? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.tripID = tripID
        self.arrival = arrival
        self.departure = departure
        self.stopID = stopID
        self.stopSequenceNumber = stopSequenceNumber
        self.stopHeadingSign = stopHeadingSign
        self.pickupType = pickupType
        self.dropOffType = dropOffType
        self.continuousPickup = continuousPickup
        self.continuousDropOff = continuousDropOff
        self.distanceTraveledForShape = distanceTraveledForShape
        self.timePointType = timePointType
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(
        from record: String,
        using headers: [StopTimeField]
    ) throws {
        do {
            let fields = try record.readRecord()
            if fields.count != headers.count {
                throw TransitError.headerRecordMismatch
            }
            for (index, header) in headers.enumerated() {
                let field = fields[index]
                switch header {
                case .tripID, .stopID:
                    try field.assignStringTo(&self, for: header)
                case .stopHeadingSign:
                    try field.assignOptionalStringTo(&self, for: header)
                case .stopSequenceNumber:
                    try field.`assignUIntTo`(&self, for: header)
                case .arrival, .departure:
                    try field.assignDateComponentsTo(&self, for: header)
                case .pickupType, .dropOffType,
                        .continuousPickup, .continuousDropOff,
                        .timePointType:
                    try field.assignOptionalIntTo(&self, for: header)
                case .nonstandard, .distanceTraveledForShape:
                    continue
                }
            }
        } catch let error {
            throw error
        }
    }
    
    func getArrivalTime() -> String {
        return arrival?.description ?? "No Time"
    }
    
    func getDepartureTime() -> String {
        return departure?.description ?? "No Time"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case tripID
        case arrival
        case departure
        case stopID
        case stopSequenceNumber
        case stopHeadingSign
        case pickupType
        case dropOffType
        case continuousPickup
        case continuousDropOff
        case distanceTraveledForShape
        case timePointType
        case nonstandard
        case startDate
        case endDate
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<StopTime.CodingKeys> = encoder.container(keyedBy: StopTime.CodingKeys.self)
        
        try container.encode(self.id, forKey: StopTime.CodingKeys.id)
        try container.encode(self.tripID, forKey: StopTime.CodingKeys.tripID)
        try container.encodeIfPresent(self.arrival, forKey: StopTime.CodingKeys.arrival)
        try container.encodeIfPresent(self.departure, forKey: StopTime.CodingKeys.departure)
        try container.encode(self.stopID, forKey: StopTime.CodingKeys.stopID)
        try container.encode(self.stopSequenceNumber, forKey: StopTime.CodingKeys.stopSequenceNumber)
        try container.encodeIfPresent(self.stopHeadingSign, forKey: StopTime.CodingKeys.stopHeadingSign)
        try container.encodeIfPresent(self.pickupType, forKey: StopTime.CodingKeys.pickupType)
        try container.encodeIfPresent(self.dropOffType, forKey: StopTime.CodingKeys.dropOffType)
        try container.encodeIfPresent(self.continuousPickup, forKey: StopTime.CodingKeys.continuousPickup)
        try container.encodeIfPresent(self.continuousDropOff, forKey: StopTime.CodingKeys.continuousDropOff)
        try container.encodeIfPresent(self.distanceTraveledForShape, forKey: StopTime.CodingKeys.distanceTraveledForShape)
        try container.encodeIfPresent(self.timePointType, forKey: StopTime.CodingKeys.timePointType)
        try container.encodeIfPresent(self.nonstandard, forKey: StopTime.CodingKeys.nonstandard)
        try container.encodeIfPresent(self.startDate, forKey: StopTime.CodingKeys.startDate)
        try container.encodeIfPresent(self.endDate, forKey: StopTime.CodingKeys.endDate)
    }
    
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<StopTime.CodingKeys> = try decoder.container(keyedBy: StopTime.CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: StopTime.CodingKeys.id)
        self.tripID = try container.decode(TransitID.self, forKey: StopTime.CodingKeys.tripID)
        self.arrival = try container.decodeIfPresent(DateComponents.self, forKey: StopTime.CodingKeys.arrival)
        self.departure = try container.decodeIfPresent(DateComponents.self, forKey: StopTime.CodingKeys.departure)
        self.stopID = try container.decode(TransitID.self, forKey: StopTime.CodingKeys.stopID)
        self.stopSequenceNumber = try container.decode(UInt.self, forKey: StopTime.CodingKeys.stopSequenceNumber)
        self.stopHeadingSign = try container.decodeIfPresent(String.self, forKey: StopTime.CodingKeys.stopHeadingSign)
        self.pickupType = try container.decodeIfPresent(Int.self, forKey: StopTime.CodingKeys.pickupType)
        self.dropOffType = try container.decodeIfPresent(Int.self, forKey: StopTime.CodingKeys.dropOffType)
        self.continuousPickup = try container.decodeIfPresent(Int.self, forKey: StopTime.CodingKeys.continuousPickup)
        self.continuousDropOff = try container.decodeIfPresent(Int.self, forKey: StopTime.CodingKeys.continuousDropOff)
        self.distanceTraveledForShape = try container.decodeIfPresent(Double.self, forKey: StopTime.CodingKeys.distanceTraveledForShape)
        self.timePointType = try container.decodeIfPresent(Int.self, forKey: StopTime.CodingKeys.timePointType)
        self.nonstandard = try container.decodeIfPresent(String.self, forKey: StopTime.CodingKeys.nonstandard)
        self.startDate = try container.decodeIfPresent(Date.self, forKey: StopTime.CodingKeys.startDate)
        self.endDate = try container.decodeIfPresent(Date.self, forKey: StopTime.CodingKeys.endDate)
    }
}

extension StopTime: Equatable {
    public static func == (lhs: StopTime, rhs: StopTime) -> Bool {
        lhs.tripID == rhs.tripID &&
        lhs.stopID == rhs.stopID &&
        lhs.arrival == rhs.arrival
    }
}

extension StopTime: CustomStringConvertible {
    public var description: String {
        return "StopTime: \(self.tripID) \(self.stopID) \(String(describing: self.endDate)) \(String(describing: self.startDate)) \(self.getArrivalTime()) \(self.getDepartureTime())"
    }
}

// MARK: - StopTimes

/// - Tag: StopTimes
public class StopTimes: Identifiable, Codable {
    public let id = UUID()
    public var headerFields = [StopTimeField]()
    public var stopTimes = [StopTime]()
    
    enum CodingKeys: CodingKey {
        case id
        case headerFields
        case stopTimes
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.headerFields, forKey: .headerFields)
        try container.encode(self.stopTimes, forKey: .stopTimes)
    }
    
    subscript(index: Int) -> StopTime {
        get {
            return stopTimes[index]
        }
        set(newValue) {
            stopTimes[index] = newValue
        }
    }
    
    func add(_ stopTime: StopTime) {
        // TODO: Add to header fields supported by this collection
        self.stopTimes.append(stopTime)
    }
    
    func remove(_ stopTime: StopTime) {
    }
    
    init<S: Sequence>(_ sequence: S)
    where S.Iterator.Element == StopTime {
        for stopTime in sequence {
            self.add(stopTime)
        }
    }
    
    init(from url: URL) throws {
        do {
            let records = try String(contentsOf: url).splitRecords()
            
            if records.count < 1 { return }
            let headerRecord = String(records[0])
            self.headerFields = try headerRecord.readHeader()
            
            self.stopTimes.reserveCapacity(records.count - 1)
            for stopTimeRecord in records[1 ..< records.count] {
                let stopTime = try StopTime(from: String(stopTimeRecord), using: headerFields)
                if stopTime.dropOffType == 0 || stopTime.pickupType == 0 {
                    self.add(stopTime)
                }
            }
        } catch let error {
            throw error
        }
    }
    
}

extension StopTimes: Sequence {
    public typealias Iterator = IndexingIterator<[StopTime]>
    
    public func makeIterator() -> Iterator {
        return stopTimes.makeIterator()
    }
}
