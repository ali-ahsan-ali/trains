// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StationsQuery: GraphQLQuery {
  public static let operationName: String = "Stations"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Stations { stations { __typename id name gtfsId } }"#
    ))

  public init() {}

  public struct Data: Trains.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Trains.Objects.QueryType }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("stations", [Station?]?.self),
    ] }

    /// Get all stations
    public var stations: [Station?]? { __data["stations"] }

    /// Station
    ///
    /// Parent Type: `Stop`
    public struct Station: Trains.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Trains.ID.self),
        .field("name", String.self),
        .field("gtfsId", String.self),
      ] }

      /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
      public var id: Trains.ID { __data["id"] }
      /// Name of the stop, e.g. Pasilan asema
      public var name: String { __data["name"] }
      /// ÌD of the stop in format `FeedId:StopId`
      public var gtfsId: String { __data["gtfsId"] }
    }
  }
}
