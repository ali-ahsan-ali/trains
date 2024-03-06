// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PlanQuery: GraphQLQuery {
  public static let operationName: String = "plan"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query plan($fromPlace: String, $toPlace: String, $numItineraries: Int, $searchWindow: Long) { plan( numItineraries: $numItineraries searchWindow: $searchWindow fromPlace: $fromPlace toPlace: $toPlace ) { __typename from { __typename name } to { __typename name } itineraries { __typename startTime endTime duration legs { __typename transitLeg serviceDate trip { __typename stoptimes { __typename realtimeArrival realtimeDeparture stop { __typename id } } } intermediateStops { __typename name id } startTime endTime duration from { __typename stop { __typename id name parentStation { __typename id } } name } to { __typename stop { __typename id name parentStation { __typename id } } name } mode interlineWithPreviousLeg } } routingErrors { __typename code inputField description } debugOutput { __typename totalTime timedOut } } }"#
    ))

  public var fromPlace: GraphQLNullable<String>
  public var toPlace: GraphQLNullable<String>
  public var numItineraries: GraphQLNullable<Int>
  public var searchWindow: GraphQLNullable<Long>

  public init(
    fromPlace: GraphQLNullable<String>,
    toPlace: GraphQLNullable<String>,
    numItineraries: GraphQLNullable<Int>,
    searchWindow: GraphQLNullable<Long>
  ) {
    self.fromPlace = fromPlace
    self.toPlace = toPlace
    self.numItineraries = numItineraries
    self.searchWindow = searchWindow
  }

  public var __variables: Variables? { [
    "fromPlace": fromPlace,
    "toPlace": toPlace,
    "numItineraries": numItineraries,
    "searchWindow": searchWindow
  ] }

  public struct Data: Trains.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Trains.Objects.QueryType }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("plan", Plan?.self, arguments: [
        "numItineraries": .variable("numItineraries"),
        "searchWindow": .variable("searchWindow"),
        "fromPlace": .variable("fromPlace"),
        "toPlace": .variable("toPlace")
      ]),
    ] }

    /// Plans an itinerary from point A to point B based on the given arguments
    public var plan: Plan? { __data["plan"] }

    /// Plan
    ///
    /// Parent Type: `Plan`
    public struct Plan: Trains.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Plan }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("from", From.self),
        .field("to", To.self),
        .field("itineraries", [Itinerary?].self),
        .field("routingErrors", [RoutingError].self),
        .field("debugOutput", DebugOutput.self),
      ] }

      /// The origin
      public var from: From { __data["from"] }
      /// The destination
      public var to: To { __data["to"] }
      /// A list of possible itineraries
      public var itineraries: [Itinerary?] { __data["itineraries"] }
      /// A list of routing errors, and fields which caused them
      public var routingErrors: [RoutingError] { __data["routingErrors"] }
      /// Information about the timings for the plan generation
      public var debugOutput: DebugOutput { __data["debugOutput"] }

      /// Plan.From
      ///
      /// Parent Type: `Place`
      public struct From: Trains.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Place }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String?.self),
        ] }

        /// For transit stops, the name of the stop. For points of interest, the name of the POI.
        public var name: String? { __data["name"] }
      }

      /// Plan.To
      ///
      /// Parent Type: `Place`
      public struct To: Trains.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Place }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String?.self),
        ] }

        /// For transit stops, the name of the stop. For points of interest, the name of the POI.
        public var name: String? { __data["name"] }
      }

      /// Plan.Itinerary
      ///
      /// Parent Type: `Itinerary`
      public struct Itinerary: Trains.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Itinerary }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("startTime", Trains.Long?.self),
          .field("endTime", Trains.Long?.self),
          .field("duration", Trains.Long?.self),
          .field("legs", [Leg?].self),
        ] }

        /// Time when the user leaves from the origin. Format: Unix timestamp in milliseconds.
        public var startTime: Trains.Long? { __data["startTime"] }
        /// Time when the user arrives to the destination.. Format: Unix timestamp in milliseconds.
        public var endTime: Trains.Long? { __data["endTime"] }
        /// Duration of the trip on this itinerary, in seconds.
        public var duration: Trains.Long? { __data["duration"] }
        /// A list of Legs. Each Leg is either a walking (cycling, car) portion of the
        /// itinerary, or a transit leg on a particular vehicle. So a itinerary where the
        /// user walks to the Q train, transfers to the 6, then walks to their
        /// destination, has four legs.
        public var legs: [Leg?] { __data["legs"] }

        /// Plan.Itinerary.Leg
        ///
        /// Parent Type: `Leg`
        public struct Leg: Trains.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Leg }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("transitLeg", Bool?.self),
            .field("serviceDate", String?.self),
            .field("trip", Trip?.self),
            .field("intermediateStops", [IntermediateStop?]?.self),
            .field("startTime", Trains.Long?.self),
            .field("endTime", Trains.Long?.self),
            .field("duration", Double?.self),
            .field("from", From.self),
            .field("to", To.self),
            .field("mode", GraphQLEnum<Trains.Mode>?.self),
            .field("interlineWithPreviousLeg", Bool?.self),
          ] }

          /// Whether this leg is a transit leg or not.
          public var transitLeg: Bool? { __data["transitLeg"] }
          /// For transit legs, the service date of the trip. Format: YYYYMMDD. For non-transit legs, null.
          public var serviceDate: String? { __data["serviceDate"] }
          /// For transit legs, the trip that is used for traversing the leg. For non-transit legs, `null`.
          public var trip: Trip? { __data["trip"] }
          /// For transit legs, intermediate stops between the Place where the leg
          /// originates and the Place where the leg ends. For non-transit legs, null.
          public var intermediateStops: [IntermediateStop?]? { __data["intermediateStops"] }
          /// The date and time when this leg begins. Format: Unix timestamp in milliseconds.
          public var startTime: Trains.Long? { __data["startTime"] }
          /// The date and time when this leg ends. Format: Unix timestamp in milliseconds.
          public var endTime: Trains.Long? { __data["endTime"] }
          /// The leg's duration in seconds
          public var duration: Double? { __data["duration"] }
          /// The Place where the leg originates.
          public var from: From { __data["from"] }
          /// The Place where the leg ends.
          public var to: To { __data["to"] }
          /// The mode (e.g. `WALK`) used when traversing this leg.
          public var mode: GraphQLEnum<Trains.Mode>? { __data["mode"] }
          /// Interlines with previous leg.
          /// This is true when the same vehicle is used for the previous leg as for this leg
          /// and passenger can stay inside the vehicle.
          public var interlineWithPreviousLeg: Bool? { __data["interlineWithPreviousLeg"] }

          /// Plan.Itinerary.Leg.Trip
          ///
          /// Parent Type: `Trip`
          public struct Trip: Trains.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Trip }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stoptimes", [Stoptime?]?.self),
            ] }

            /// List of times when this trip arrives to or departs from a stop
            public var stoptimes: [Stoptime?]? { __data["stoptimes"] }

            /// Plan.Itinerary.Leg.Trip.Stoptime
            ///
            /// Parent Type: `Stoptime`
            public struct Stoptime: Trains.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stoptime }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("realtimeArrival", Int?.self),
                .field("realtimeDeparture", Int?.self),
                .field("stop", Stop?.self),
              ] }

              /// Realtime prediction of arrival time. Format: seconds since midnight of the departure date
              public var realtimeArrival: Int? { __data["realtimeArrival"] }
              /// Realtime prediction of departure time. Format: seconds since midnight of the departure date
              public var realtimeDeparture: Int? { __data["realtimeDeparture"] }
              /// The stop where this arrival/departure happens
              public var stop: Stop? { __data["stop"] }

              /// Plan.Itinerary.Leg.Trip.Stoptime.Stop
              ///
              /// Parent Type: `Stop`
              public struct Stop: Trains.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", Trains.ID.self),
                ] }

                /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
                public var id: Trains.ID { __data["id"] }
              }
            }
          }

          /// Plan.Itinerary.Leg.IntermediateStop
          ///
          /// Parent Type: `Stop`
          public struct IntermediateStop: Trains.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String.self),
              .field("id", Trains.ID.self),
            ] }

            /// Name of the stop, e.g. Pasilan asema
            public var name: String { __data["name"] }
            /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
            public var id: Trains.ID { __data["id"] }
          }

          /// Plan.Itinerary.Leg.From
          ///
          /// Parent Type: `Place`
          public struct From: Trains.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Place }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stop", Stop?.self),
              .field("name", String?.self),
            ] }

            /// The stop related to the place.
            public var stop: Stop? { __data["stop"] }
            /// For transit stops, the name of the stop. For points of interest, the name of the POI.
            public var name: String? { __data["name"] }

            /// Plan.Itinerary.Leg.From.Stop
            ///
            /// Parent Type: `Stop`
            public struct Stop: Trains.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", Trains.ID.self),
                .field("name", String.self),
                .field("parentStation", ParentStation?.self),
              ] }

              /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
              public var id: Trains.ID { __data["id"] }
              /// Name of the stop, e.g. Pasilan asema
              public var name: String { __data["name"] }
              /// The station which this stop is part of (or null if this stop is not part of a station)
              public var parentStation: ParentStation? { __data["parentStation"] }

              /// Plan.Itinerary.Leg.From.Stop.ParentStation
              ///
              /// Parent Type: `Stop`
              public struct ParentStation: Trains.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", Trains.ID.self),
                ] }

                /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
                public var id: Trains.ID { __data["id"] }
              }
            }
          }

          /// Plan.Itinerary.Leg.To
          ///
          /// Parent Type: `Place`
          public struct To: Trains.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Place }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("stop", Stop?.self),
              .field("name", String?.self),
            ] }

            /// The stop related to the place.
            public var stop: Stop? { __data["stop"] }
            /// For transit stops, the name of the stop. For points of interest, the name of the POI.
            public var name: String? { __data["name"] }

            /// Plan.Itinerary.Leg.To.Stop
            ///
            /// Parent Type: `Stop`
            public struct Stop: Trains.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", Trains.ID.self),
                .field("name", String.self),
                .field("parentStation", ParentStation?.self),
              ] }

              /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
              public var id: Trains.ID { __data["id"] }
              /// Name of the stop, e.g. Pasilan asema
              public var name: String { __data["name"] }
              /// The station which this stop is part of (or null if this stop is not part of a station)
              public var parentStation: ParentStation? { __data["parentStation"] }

              /// Plan.Itinerary.Leg.To.Stop.ParentStation
              ///
              /// Parent Type: `Stop`
              public struct ParentStation: Trains.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType { Trains.Objects.Stop }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", Trains.ID.self),
                ] }

                /// Global object ID provided by Relay. This value can be used to refetch this object using **node** query.
                public var id: Trains.ID { __data["id"] }
              }
            }
          }
        }
      }

      /// Plan.RoutingError
      ///
      /// Parent Type: `RoutingError`
      public struct RoutingError: Trains.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Trains.Objects.RoutingError }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("code", GraphQLEnum<Trains.RoutingErrorCode>.self),
          .field("inputField", GraphQLEnum<Trains.InputField>?.self),
          .field("description", String.self),
        ] }

        /// An enum describing the reason
        public var code: GraphQLEnum<Trains.RoutingErrorCode> { __data["code"] }
        /// An enum describing the field which should be changed, in order for the search to succeed
        public var inputField: GraphQLEnum<Trains.InputField>? { __data["inputField"] }
        /// A textual description of why the search failed. The clients are expected to have their own translations based on the code, for user visible error messages.
        public var description: String { __data["description"] }
      }

      /// Plan.DebugOutput
      ///
      /// Parent Type: `DebugOutput`
      public struct DebugOutput: Trains.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Trains.Objects.DebugOutput }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("totalTime", Trains.Long?.self),
          .field("timedOut", Bool?.self),
        ] }

        public var totalTime: Trains.Long? { __data["totalTime"] }
        public var timedOut: Bool? { __data["timedOut"] }
      }
    }
  }
}
