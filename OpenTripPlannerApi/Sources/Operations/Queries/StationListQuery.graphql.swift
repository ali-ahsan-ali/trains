// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Foundation

public class StationListQuery: GraphQLQuery {
  public static let operationName: String = "StationList"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query StationList { stations { __typename name lon lat } }"#
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
      public struct Station: OpenTripPlannerApi.SelectionSet, Identifiable {

      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { OpenTripPlannerApi.Objects.Stop }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("name", String.self),
        .field("lon", Double?.self),
        .field("lat", Double?.self),
      ] }

      /// Name of the stop, e.g. Pasilan asema
      public var name: String { __data["name"] }
      /// Longitude of the stop (WGS 84)
      public var lon: Double? { __data["lon"] }
      /// Latitude of the stop (WGS 84)
      public var lat: Double? { __data["lat"] }

      public let id = UUID()
    }
  }
}
