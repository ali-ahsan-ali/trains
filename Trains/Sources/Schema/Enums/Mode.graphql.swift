// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public enum Mode: String, EnumType {
  /// AIRPLANE
  case airplane = "AIRPLANE"
  /// BICYCLE
  case bicycle = "BICYCLE"
  /// BUS
  case bus = "BUS"
  /// CABLE_CAR
  case cableCar = "CABLE_CAR"
  /// CAR
  case car = "CAR"
  /// COACH
  case coach = "COACH"
  /// FERRY
  case ferry = "FERRY"
  /// Enables flexible transit for access and egress legs
  case flex = "FLEX"
  /// Enables flexible transit for access and egress legs
  ///
  /// **Deprecated**: Use FLEX instead
  case flexible = "FLEXIBLE"
  /// FUNICULAR
  case funicular = "FUNICULAR"
  /// GONDOLA
  case gondola = "GONDOLA"
  /// Only used internally. No use for API users.
  ///
  /// **Deprecated**: No longer supported
  case legSwitch = "LEG_SWITCH"
  /// RAIL
  case rail = "RAIL"
  /// SCOOTER
  case scooter = "SCOOTER"
  /// SUBWAY
  case subway = "SUBWAY"
  /// TRAM
  case tram = "TRAM"
  /// "Private car trips shared with others.
  case carpool = "CARPOOL"
  /// A taxi, possibly operated by a public transport agency.
  case taxi = "TAXI"
  /// A special transport mode, which includes all public transport.
  case transit = "TRANSIT"
  /// WALK
  case walk = "WALK"
  /// Electric buses that draw power from overhead wires using poles.
  case trolleybus = "TROLLEYBUS"
  /// Railway in which the track consists of a single rail or a beam.
  case monorail = "MONORAIL"
}
