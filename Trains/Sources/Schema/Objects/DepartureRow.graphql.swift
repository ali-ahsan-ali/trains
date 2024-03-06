// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// Departure row is a combination of a pattern and a stop of that pattern.
  ///
  /// They are de-duplicated so for each pattern there will only be a single departure row.
  ///
  /// This is useful if you want to show a list of stop/pattern combinations but want each pattern to be
  /// listed only once.
  static let DepartureRow = ApolloAPI.Object(
    typename: "DepartureRow",
    implementedInterfaces: [
      Interfaces.Node.self,
      Interfaces.PlaceInterface.self
    ]
  )
}