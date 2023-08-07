// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StationListQuery: GraphQLQuery {
  public static let operationName: String = "StationList"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query StationList { stations { __typename id name lon lat stops { __typename id name } } }"#
    ))

  public init() {}

  public struct Data: OpenTripPlannerApi.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { OpenTripPlannerApi.Objects.QueryType }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("stations", [Station?]?.self),
    ] }

    /// Get all stations
    public var stations: [Station?]? { __data["stations"] }

    /// Station
    ///
    /// Parent Type: `Stop`
    public struct Station: OpenTripPlannerApi.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { OpenTripPlannerApi.Objects.Stop }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", OpenTripPlannerApi.ID.self),
        .field("name", String.self),
        .field("lon", Double?.self),
        .field("lat", Double?.self),
        .field("stops", [Stop?]?.self),
      ] }

      /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
      public var id: OpenTripPlannerApi.ID { __data["id"] }
      /// Name of the stop, e.g. Pasilan asema
      public var name: String { __data["name"] }
      /// Longitude of the stop (WGS 84)
      public var lon: Double? { __data["lon"] }
      /// Latitude of the stop (WGS 84)
      public var lat: Double? { __data["lat"] }
      /// Returns all stops that are children of this station (Only applicable for stations)
      public var stops: [Stop?]? { __data["stops"] }

      /// Station.Stop
      ///
      /// Parent Type: `Stop`
      public struct Stop: OpenTripPlannerApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { OpenTripPlannerApi.Objects.Stop }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", OpenTripPlannerApi.ID.self),
          .field("name", String.self),
        ] }

        /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
        public var id: OpenTripPlannerApi.ID { __data["id"] }
        /// Name of the stop, e.g. Pasilan asema
        public var name: String { __data["name"] }
      }
    }
  }
}
