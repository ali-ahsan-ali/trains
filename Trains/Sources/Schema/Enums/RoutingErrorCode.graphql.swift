// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public enum RoutingErrorCode: String, EnumType {
  /// No transit connection was found between the origin and destination within the operating day or
  /// the next day, not even sub-optimal ones.
  case noTransitConnection = "NO_TRANSIT_CONNECTION"
  /// A transit connection was found, but it was outside the search window. See the metadata for a token
  /// for retrieving the result outside the search window.
  case noTransitConnectionInSearchWindow = "NO_TRANSIT_CONNECTION_IN_SEARCH_WINDOW"
  /// The date specified is outside the range of data currently loaded into the system as it is too
  /// far into the future or the past.
  ///
  /// The specific date range of the system is configurable by an administrator and also depends on
  /// the input data provided.
  case outsideServicePeriod = "OUTSIDE_SERVICE_PERIOD"
  /// The coordinates are outside the geographic bounds of the transit and street data currently loaded
  /// into the system and therefore cannot return any results.
  case outsideBounds = "OUTSIDE_BOUNDS"
  /// The specified location is not close to any streets or transit stops currently loaded into the
  /// system, even though it is generally within its bounds.
  ///
  /// This can happen when there is only transit but no street data coverage at the location in
  /// question.
  case locationNotFound = "LOCATION_NOT_FOUND"
  /// No stops are reachable from the start or end locations specified.
  ///
  /// You can try searching using a different access or egress mode, for example cycling instead of walking,
  /// increase the walking/cycling/driving speed or have an administrator change the system's configuration
  /// so that stops further away are considered.
  case noStopsInRange = "NO_STOPS_IN_RANGE"
  /// Transit connections were requested and found but because it is easier to just walk all the way
  /// to the destination they were removed.
  ///
  /// If you want to still show the transit results, you need to make walking less desirable by
  /// increasing the walk reluctance.
  case walkingBetterThanTransit = "WALKING_BETTER_THAN_TRANSIT"
}
