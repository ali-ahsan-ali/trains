//
// Route.swift
//

// swiftlint:disable todo

import Foundation
import CoreGraphics
import UIKit

// MARK: RouteField

/// Describes the various fields found within a ``Route`` record or header.
///
/// `RouteField`s are generally members of `Set`s that enumerate
/// the fields found within a ``Route`` record or header. The following,
/// for example, returns the `Set` of route fields found within
/// the `myRoutes` feed header:
/// ```swift
///   let fields = myRoutes.headerFields
/// ```
///
/// Should you need it, use `rawValue` to obtain the GTFS route field name
/// associated with an `RouteField` value as a `String`:
/// ```swift
///   let gtfsField = RouteField.details.rawValue  //  Returns "route_desc"
/// ```
public enum RouteField: String, Hashable, KeyPathVending, Codable{
  /// Route ID field.
  case routeID = "route_id"
  /// Agency ID field.
  case agencyID = "agency_id"
  /// Route name field.
  case name = "route_long_name"
  /// Route short name field.
  case shortName = "route_short_name"
  /// Route details field.
  case details = "route_desc"
  /// Route type field.
  case type = "route_type"
  /// Route URL field.
  case url = "route_url"
  /// Route color field.
  case color = "route_color"
  /// Route text color field.
  case textColor = "route_text_color"
  /// Route sort order field.
  case sortOrder = "route_sort_order"
  /// Route pickup policy field.
  case pickupPolicy = "continuous_pickup"
  /// Route drop off policy field.
  case dropOffPolicy = "continuous_drop_off"
	/// Used when a nonstandard field is found within a GTFS feed.
	case nonstandard = "nonstandard"
	
  internal var path: AnyKeyPath {
    switch self {
    case .routeID: return \Route.routeID
    case .agencyID: return \Route.agencyID
    case .name: return \Route.name
    case .shortName: return \Route.shortName
    case .details: return \Route.details
    case .type: return \Route.type
    case .url: return \Route.url
    case .color: return \Route.color
    case .textColor: return \Route.textColor
    case .sortOrder: return \Route.sortOrder
    case .pickupPolicy: return \Route.pickupPolicy
    case .dropOffPolicy: return \Route.dropOffPolicy
		case .nonstandard: return \Route.nonstandard
    }
  }
}

// MARK: - RouteField

public enum RouteType: UInt, Hashable, Codable{
  case tram = 0
  case subway = 1
  case rail = 2
  case bus = 3
  case ferry = 4
  case cable = 5
  case aerial = 6
  case funicular = 7
  case trolleybus = 11
    case monorail = 12
}

public enum PickupDropOffPolicy: UInt, Hashable, Codable{
  case continuous = 0
  case none = 1
  case coordinateWithAgency = 2
    case coordinateWithDriver = 3
}

// MARK: - Route

/// A representation of a single Route record.
public struct Route: Hashable, Identifiable, Codable{
   
    public var id = UUID()
  public var routeID: TransitID = ""
  public var agencyID: TransitID?
  public var name: String?
  public var shortName: String?
  public var details: String?
  public var type: RouteType = .bus
  public var url: URL?
  public var color: CodableCGColor?
  public var textColor: CodableCGColor?
  public var sortOrder: UInt?
  public var pickupPolicy: PickupDropOffPolicy?
  public var dropOffPolicy: PickupDropOffPolicy?
	public var nonstandard: String? = nil

  public static let requiredFields: Set<RouteField>
    = [.routeID, .type]
  public static let conditionallyRequiredFields: Set<RouteField>
    = [.agencyID, .name, .shortName]
  public static let optionalFields: Set<RouteField>
    = [.details, .url, .color, .textColor, .sortOrder,
       .pickupPolicy, .dropOffPolicy]

  public init(
		routeID: TransitID = "Unidentified route",
		agencyID: TransitID? = nil,
		name: String? = nil,
		shortName: String? = nil,
		details: String? = nil,
		type: RouteType = .bus,
		url: URL? = nil,
		color: CGColor? = nil,
		textColor: CGColor? = nil,
		sortOrder: UInt? = nil,
		pickupPolicy: PickupDropOffPolicy? = nil,
		dropOffPolicy: PickupDropOffPolicy? = nil
	) {
    self.routeID = routeID
    self.agencyID = agencyID
    self.name = name
    self.shortName = shortName
    self.details = details
    self.type = type
    self.url = url
    self.color = CodableCGColor(cgColor: color)
    self.textColor = CodableCGColor(cgColor: textColor)
    self.sortOrder = sortOrder
    self.pickupPolicy = pickupPolicy
    self.dropOffPolicy = dropOffPolicy
  }

  public init(from record: String, using headers: [RouteField]) throws {
    do {
      let fields = try record.readRecord()
      if fields.count != headers.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headers.enumerated() {
        let field = fields[index]
        switch header {
        case .routeID:
          try field.assignStringTo(&self, for: header)
        case .agencyID, .name, .shortName, .details:
          try field.assignOptionalStringTo(&self, for: header)
        case .sortOrder:
          try field.assignOptionalUIntTo(&self, for: header)
        case .url:
          try field.assignOptionalURLTo(&self, for: header)
        case .color, .textColor:
          try field.assignOptionalCGColorTo(&self, for: header)
        case .type:
          try field.assignRouteTypeTo(&self, for: header)
        case .pickupPolicy, .dropOffPolicy:
          try field.assignOptionalPickupDropOffPolicyTo(&self, for: header)
				case .nonstandard:
					continue
        }
      }
    } catch let error {
      throw error
    }
  }

  public static func routeTypeFrom(string: String) -> RouteType? {
    if let rawValue = UInt(string) {
      return RouteType(rawValue: rawValue)
    } else {
      return nil
    }
  }

  public static func pickupDropOffPolicyFrom(string: String)
		-> PickupDropOffPolicy? {
    if let rawValue = UInt(string) {
      return PickupDropOffPolicy(rawValue: rawValue)
    } else {
      return nil
    }
  }

  private static let requiredHeaders: Set =
    [RouteField.routeID, RouteField.type]

	public func hasRequiredFields() -> Bool {
		return true
	}

	public func hasConditionallyRequiredFields() -> Bool {
		return true
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(routeID, forKey: .routeID)
        try container.encode(agencyID, forKey: .agencyID)
        try container.encode(name, forKey: .name)
        try container.encode(shortName, forKey: .shortName)
        try container.encode(details, forKey: .details)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
        try container.encode(color, forKey: .color)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(pickupPolicy, forKey: .pickupPolicy)
        try container.encode(dropOffPolicy, forKey: .dropOffPolicy)
        try container.encode(nonstandard, forKey: .nonstandard)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        routeID = try container.decode(TransitID.self, forKey: .routeID)
        agencyID = try container.decodeIfPresent(TransitID.self, forKey: .agencyID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        type = try container.decode(RouteType.self, forKey: .type)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        color = try container.decodeIfPresent(CodableCGColor.self, forKey: .color)
        textColor = try container.decodeIfPresent(CodableCGColor.self, forKey: .textColor)
        sortOrder = try container.decodeIfPresent(UInt.self, forKey: .sortOrder)
        pickupPolicy = try container.decodeIfPresent(PickupDropOffPolicy.self, forKey: .pickupPolicy)
        dropOffPolicy = try container.decodeIfPresent(PickupDropOffPolicy.self, forKey: .dropOffPolicy)
        nonstandard = try container.decodeIfPresent(String.self, forKey: .nonstandard)
    }

    
    enum CodingKeys: CodingKey {
        case id
        case routeID
        case agencyID
        case name
        case shortName
        case details
        case type
        case url
        case color
        case textColor
        case sortOrder
        case pickupPolicy
        case dropOffPolicy
      case nonstandard
    }

}

extension Route: Equatable {
  public static func == (lhs: Route, rhs: Route) -> Bool {
    return
      lhs.routeID == rhs.routeID &&
      lhs.agencyID == rhs.agencyID &&
      lhs.name == rhs.name &&
      lhs.shortName == rhs.shortName &&
      lhs.details == rhs.details &&
      lhs.type == rhs.type &&
      lhs.url == rhs.url &&
      lhs.color == rhs.color &&
      lhs.textColor == rhs.textColor &&
      lhs.sortOrder == rhs.sortOrder &&
      lhs.pickupPolicy == rhs.pickupPolicy &&
      lhs.dropOffPolicy == rhs.dropOffPolicy
  }
}

extension Route: CustomStringConvertible {
  public var description: String {
    return "Route: \(self.routeID)"
  }
}

// MARK: - Routes

/// A representation of a complete Route dataset.
public struct Routes: Identifiable, Encodable, Decodable {
  public let id = UUID()
  public var headerFields = [RouteField]()
	public var routes: [Route] = []
	
	// TODO: Routes method to ensure that feed with mutiple agencies does not omit
	// TODO:   agencyIDs if routes refer to both agencies.
	// TODO: Routes method to ensure that either name or shortName provided for all
	// TODO:   routes.
	
  subscript(index: Int) -> Route {
    get {
      return routes[index]
    }
    set(newValue) {
      routes[index] = newValue
    }
  }

  mutating func add(_ route: Route) {
    self.routes.append(route)
  }

  mutating func remove(_ route: Route) {
  }

  init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == Route {
    for route in sequence {
      self.add(route)
    }
  }

  init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()

      if records.count <= 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()

      self.routes.reserveCapacity(records.count - 1)
      for routeRecord in records[1 ..< records.count] {
        let route = try Route(from: String(routeRecord), using: headerFields)
				//print(route)
        self.add(route)
      }
    } catch let error {
      throw error
    }
  }
    
    enum CodingKeys: CodingKey {
        case id
        case headerFields
        case routes
    }
    
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Routes.CodingKeys> = try decoder.container(keyedBy: Routes.CodingKeys.self)
        
        self.headerFields = try container.decode([RouteField].self, forKey: Routes.CodingKeys.headerFields)
        self.routes = try container.decode([Route].self, forKey: Routes.CodingKeys.routes)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Routes.CodingKeys.self)
        
        try container.encode(self.id, forKey: Routes.CodingKeys.id)
        try container.encode(self.headerFields, forKey: Routes.CodingKeys.headerFields)
        try container.encode(self.routes, forKey: Routes.CodingKeys.routes)
    }
}

extension Routes: Sequence {

	public typealias Iterator = IndexingIterator<[Route]>

  public func makeIterator() -> Iterator {
    return routes.makeIterator()
  }

}


public struct CodableCGColor: Hashable, Codable {
    public let components: [CGFloat]
    
    public init(cgColor: CGColor?) {
        if let components = cgColor?.components {
            self.components = components
        } else {
            self.components = []
        }
    }
    
    public var cgColor: CGColor? {
        guard components.count >= 4 else { return nil }
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
                       components: components)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(components)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        components = try container.decode([CGFloat].self)
    }
}
