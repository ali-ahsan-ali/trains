//
// Calendar.swift
//

import Foundation
import CoreLocation

// MARK: CalendarField
public enum CalendarField: String, Hashable, Codable{
    case service_id = "service_id"
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    case start_date = "start_date"
    case end_date = "end_date"
}

/// A representation of a single Stop record.
public class CalendarRow: Hashable, Identifiable, Codable{

    public var id = UUID()
    public var service_id: String  = ""
    public var monday: Bool = false
    public var tuesday: Bool  = false
    public var wednesday: Bool = false
    public var thursday: Bool  = false
    public var friday: Bool = false
    public var saturday: Bool = false
    public var sunday: Bool = false
    public var start_date: Date?  = nil
    public var end_date: Date?  = nil
    
    internal init(
        service_id: String = "",
        monday: Bool = false,
        tuesday: Bool = false,
        wednesday: Bool = false,
        thursday: Bool = false,
        friday: Bool = false,
        saturday: Bool = false,
        sunday: Bool = false,
        start_date: Date? = nil,
        end_date: Date? = nil
    ) {
        self.service_id = service_id
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
        self.start_date = start_date
        self.end_date = end_date
    }
    
    var weekDays: [Int] {
        var weekDays: [Int] = []
        if sunday { weekDays.append(1)}
        if monday { weekDays.append(2)}
        if tuesday { weekDays.append(3)}
        if wednesday { weekDays.append(4)}
        if thursday { weekDays.append(5)}
        if friday { weekDays.append(6)}
        if saturday { weekDays.append(7)}
        return weekDays
    }
    
    public static let requiredFields: Set =
    [StopField.stopID]
    
    init(from record: String, using headers: [CalendarField]) throws {
        do {
            let fields = try record.readRecord()
            if fields.count != headers.count {
                throw TransitError.headerRecordMismatch
            }
            for (index, header) in headers.enumerated() {
                let field = fields[index]
                switch header {
                case .service_id:
                    self.service_id = field
                case .monday:
                    self.monday = field == "0" ? false : true
                case .tuesday:
                    self.tuesday = field == "0" ? false : true
                case .wednesday:
                    self.wednesday = field == "0" ? false : true
                case .thursday:
                    self.thursday = field == "0" ? false : true
                case .friday:
                    self.friday = field == "0" ? false : true
                case .saturday:
                    self.saturday = field == "0" ? false : true
                case .sunday:
                    self.sunday = field == "0" ? false : true
                case .start_date:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    dateFormatter.timeZone = TimeZone(identifier: "Australia/Sydney")
                    self.start_date = dateFormatter.date(from: field)
                case .end_date:
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = .current
                    dateFormatter.timeZone = TimeZone(identifier: "Australia/Sydney")
                    self.end_date = dateFormatter.date(from: field)
                }
            }
        }catch let error {
            throw error
        }
    }
            
            
    private static let requiredHeaders: Set =
    [CalendarField.service_id]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(service_id)
        
    }
    public static func == (lhs: CalendarRow, rhs: CalendarRow) -> Bool {
        lhs.service_id == rhs.service_id
    }
    public var description: String {
        return "Row: \(self.service_id) \(self.weekDays) \(String(describing: self.start_date)) \(String(describing: self.end_date))"
    }
        
}

// MARK: - Stops

/// A representation of a complete Stops dataset.
public class GTFSCalendar: Identifiable, Codable{
    public let id = UUID()
    public var headerFields = [CalendarField]()
    public var serviceAvailability = [CalendarRow]()
    
    subscript(index: Int) -> CalendarRow {
        get {
            return serviceAvailability[index]
        }
        set(newValue) {
            serviceAvailability[index] = newValue
        }
    }
    
    init<S: Sequence>(_ sequence: S)
    where S.Iterator.Element == CalendarRow {
        for stop in sequence {
            self.serviceAvailability.append(stop)
        }
    }
    
    init(from url: URL) throws {
        do {
            let records = try String(contentsOf: url).splitRecords()
            
            if records.count <= 1 { return }
            let headerRecord = String(records[0])
            self.headerFields = try headerRecord.readHeader()
            
            self.serviceAvailability.reserveCapacity(records.count - 1)
            for calenderRecord in records[1 ..< records.count] {
                let calendarRow = try CalendarRow(from: String(calenderRecord), using: headerFields)
                self.serviceAvailability.append(calendarRow)
            }
        } catch let error {
            throw error
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case headerFields
        case serviceAvailability
    }
}

extension GTFSCalendar: Sequence {
    public typealias Iterator = IndexingIterator<[CalendarRow]>
    
    public func makeIterator() -> Iterator {
        return serviceAvailability.makeIterator()
    }
}
