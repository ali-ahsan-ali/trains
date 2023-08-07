// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == OpenTripPlannerApi.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == OpenTripPlannerApi.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == OpenTripPlannerApi.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == OpenTripPlannerApi.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "QueryType": return OpenTripPlannerApi.Objects.QueryType
    case "Plan": return OpenTripPlannerApi.Objects.Plan
    case "Place": return OpenTripPlannerApi.Objects.Place
    case "Itinerary": return OpenTripPlannerApi.Objects.Itinerary
    case "Leg": return OpenTripPlannerApi.Objects.Leg
    case "Trip": return OpenTripPlannerApi.Objects.Trip
    case "Agency": return OpenTripPlannerApi.Objects.Agency
    case "Alert": return OpenTripPlannerApi.Objects.Alert
    case "BikePark": return OpenTripPlannerApi.Objects.BikePark
    case "VehicleParking": return OpenTripPlannerApi.Objects.VehicleParking
    case "BikeRentalStation": return OpenTripPlannerApi.Objects.BikeRentalStation
    case "VehicleRentalStation": return OpenTripPlannerApi.Objects.VehicleRentalStation
    case "RentalVehicle": return OpenTripPlannerApi.Objects.RentalVehicle
    case "CarPark": return OpenTripPlannerApi.Objects.CarPark
    case "DepartureRow": return OpenTripPlannerApi.Objects.DepartureRow
    case "Stop": return OpenTripPlannerApi.Objects.Stop
    case "Cluster": return OpenTripPlannerApi.Objects.Cluster
    case "Pattern": return OpenTripPlannerApi.Objects.Pattern
    case "placeAtDistance": return OpenTripPlannerApi.Objects.PlaceAtDistance
    case "Route": return OpenTripPlannerApi.Objects.Route
    case "stopAtDistance": return OpenTripPlannerApi.Objects.StopAtDistance
    case "TicketType": return OpenTripPlannerApi.Objects.TicketType
    case "Stoptime": return OpenTripPlannerApi.Objects.Stoptime
    case "RoutingError": return OpenTripPlannerApi.Objects.RoutingError
    case "debugOutput": return OpenTripPlannerApi.Objects.DebugOutput
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
