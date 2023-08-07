// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public enum RoutingErrorCode: String, EnumType {
  /// No transit connection was found between the origin and destination withing the operating day or the next day
  case noTransitConnection = "NO_TRANSIT_CONNECTION"
  /// Transit connection was found, but it was outside the search window, see metadata for the next search window
  case noTransitConnectionInSearchWindow = "NO_TRANSIT_CONNECTION_IN_SEARCH_WINDOW"
  /// The date specified is outside the range of data currently loaded into the system
  case outsideServicePeriod = "OUTSIDE_SERVICE_PERIOD"
  /// The coordinates are outside the bounds of the data currently loaded into the system
  case outsideBounds = "OUTSIDE_BOUNDS"
  /// The specified location is not close to any streets or transit stops
  case locationNotFound = "LOCATION_NOT_FOUND"
  /// No stops are reachable from the location specified. You can try searching using a different access or egress mode
  case noStopsInRange = "NO_STOPS_IN_RANGE"
  /// The origin and destination are so close to each other, that walking is always better, but no direct mode was specified for the search
  case walkingBetterThanTransit = "WALKING_BETTER_THAN_TRANSIT"
  /// An unknown error happened during the search. The details have been logged to the server logs
  case systemError = "SYSTEM_ERROR"
}
