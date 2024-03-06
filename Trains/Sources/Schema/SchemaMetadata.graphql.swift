// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Trains.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Trains.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Trains.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Trains.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "QueryType": return Trains.Objects.QueryType
    case "Plan": return Trains.Objects.Plan
    case "Place": return Trains.Objects.Place
    case "Itinerary": return Trains.Objects.Itinerary
    case "Leg": return Trains.Objects.Leg
    case "Trip": return Trains.Objects.Trip
    case "Agency": return Trains.Objects.Agency
    case "Alert": return Trains.Objects.Alert
    case "BikePark": return Trains.Objects.BikePark
    case "VehicleParking": return Trains.Objects.VehicleParking
    case "BikeRentalStation": return Trains.Objects.BikeRentalStation
    case "VehicleRentalStation": return Trains.Objects.VehicleRentalStation
    case "RentalVehicle": return Trains.Objects.RentalVehicle
    case "CarPark": return Trains.Objects.CarPark
    case "DepartureRow": return Trains.Objects.DepartureRow
    case "Stop": return Trains.Objects.Stop
    case "Cluster": return Trains.Objects.Cluster
    case "Pattern": return Trains.Objects.Pattern
    case "placeAtDistance": return Trains.Objects.PlaceAtDistance
    case "Route": return Trains.Objects.Route
    case "stopAtDistance": return Trains.Objects.StopAtDistance
    case "TicketType": return Trains.Objects.TicketType
    case "Stoptime": return Trains.Objects.Stoptime
    case "RoutingError": return Trains.Objects.RoutingError
    case "debugOutput": return Trains.Objects.DebugOutput
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
