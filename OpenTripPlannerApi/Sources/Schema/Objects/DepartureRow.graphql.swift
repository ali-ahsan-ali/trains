// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// Departure row is a location, which lists departures of a certain pattern from a
  /// stop. Departure rows are identified with the pattern, so querying departure rows
  /// will return only departures from one stop per pattern
  static let DepartureRow = Object(
    typename: "DepartureRow",
    implementedInterfaces: [
      Interfaces.Node.self,
      Interfaces.PlaceInterface.self
    ]
  )
}