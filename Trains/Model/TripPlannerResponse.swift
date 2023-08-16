//
//  TripPlannerResponse.swift
//  Trains
//
//  Created by Ali, Ali on 15/8/2023.
//

import Foundation

// swiftlint:disable discouraged_optional_boolean
struct TripRequestResponse: Codable {
  let version: String?
  let error: ApiErrorResponse?
  let systemMessages: [TripRequestResponseMessage]?
  let journeys: [TripRequestResponseJourney]?
}

struct ApiErrorResponse: Codable {
  let message: String?
  let versions: InlineModel?
}

struct TripRequestResponseMessage: Codable {
  let type: String?
  let module: String?
  let code: Int?
  let error: String?
}

struct TripRequestResponseJourney: Codable {
  let rating: Int?
  let isAdditional: Bool?
  let legs: [TripRequestResponseJourneyLeg]?
  let fare: InlineModel1?
}

struct InlineModel: Codable {
  let controller: String?
  let interfaceMax: String?
  let interfaceMin: String?
}

struct TripRequestResponseJourneyLeg: Codable {
  let duration: Int?
  let distance: Int?
  let isRealtimeControlled: Bool?
  let origin: TripRequestResponseJourneyLegStop?
  let destination: TripRequestResponseJourneyLegStop?
  let transportation: TripTransportation?
  let hints: [InlineModel2]?
  let stopSequence: [TripRequestResponseJourneyLegStop]?
  let footPathInfo: [TripRequestResponseJourneyLegStopFootpathInfo]?
  let infos: [TripRequestResponseJourneyLegStopInfo]?
  let pathDescriptions: [TripRequestResponseJourneyLegPathDescription]?
  let interchange: TripRequestResponseJourneyLegInterchange?
  let coords: [InlineModel1]?
  let properties: InlineModel3?
}

struct InlineModel1: Codable {
  let number: Int
}

struct InlineModel2: Codable {
  let infoText: String?
}

struct TripRequestResponseJourneyLegStopFootpathInfo: Codable {
  let position: String?
  let duration: Int?
  let footPathElem: [TripRequestResponseJourneyLegStopFootpathInfoFootpathElem]?
}

struct TripRequestResponseJourneyLegStopInfo: Codable {
  let timestamps: AdditionalInfoResponseTimestamps?
  let priority: String?
  let id: String?
  let version: String?
  let urlText: String?
  let url: String?
  let content: String?
  let subtitle: String?
}

struct TripRequestResponseJourneyLegPathDescription: Codable {
  let turnDirection: String?
  let manoeuvre: String?
  let name: String?
  let coord: [Double]?
  let skyDirection: Int?
  let duration: Int?
  let cumDuration: Int?
  let distance: Int?
  let distanceUp: Int?
  let distanceDown: Int?
  let cumDistance: Int?
  let fromCoordsIndex: Int?
  let toCoordsIndex: Int?
}

struct TripRequestResponseJourneyLegInterchange: Codable {
  let desc: String?
  let type: Int?
  let coords: [Inline_Model_2]?
}

struct Inline_Model_2: Codable {
  let number: Double
}

struct InlineModel3: Codable {
  let vehicleAccess: [String]?
  let PlanLowFloorVehicle: String?
  let PlanWheelChairAccess: String?
  let lineType: String?
  let DIFFERENT_FARES: String?
}

struct InlineModel4: Codable {
  let id: String?
  let type: String?
  let coord: [Double]?
}

struct TripRequestResponseJourneyLegStopDownload: Codable {
  let type: String?
  let url: String?
}

struct TripRequestResponseJourneyLegStopFootpathInfoFootpathElemLocation: Codable {
  let location: InlineModel4?
  let area: Int?
  let platform: Int?
  let georef: String?
}

struct AdditionalInfoResponseTimestamps: Codable {
  let creation: String?
  let lastModification: String?
  let availability: InlineModel13?
  let validity: [InlineModel14]?
}

struct InlineModel13: Codable {
  let from: String?
  let to: String?
}

struct InlineModel14: Codable {
  let from: String?
  let to: String?
}

struct InlineModel6: Codable {
  let riderCategoryName: String?
  let priceStationAccessFee: String?
  let priceTotalFare: String?
  let evaluationTicket: String?
}

struct TripRequestResponseJourneyFareZone: Codable {
  let net: String?
  let toLeg: Int?
  let fromLeg: Int?
  let neutralZone: String?
}

struct ParentLocation: Codable {
  let id: String?
  let name: String?
  let disassembledName: String?
  let type: String?
  //let parent: ParentLocation? Throws error
}

struct TripTransportation: Codable {
  let id: String?
  let name: String?
  let disassembledName: String?
  let number: String?
  let iconId: Int?
  let description: String?
  let product: RouteProduct?
  let `operator`: InlineModel7?
  let destination: InlineModel8?
  let properties: InlineModel9?
}

struct InlineModel7: Codable {
  let id: String?
  let name: String?
}

struct InlineModel8: Codable {
  let id: String?
  let name: String?
}

struct InlineModel9: Codable {
  let tripCode: Int?
  let isTTB: Bool?
}

struct TripRequestResponseJourneyLegStop: Codable {
  let id: String?
  let name: String?
  let disassembledName: String?
  let type: String?
  let coord: [Double]?
  let parent: ParentLocation?
  let departureTimeEstimated: String?
  let departureTimePlanned: String?
  let arrivalTimeEstimated: String?
  let arrivalTimePlanned: String?
  let properties: InlineModel3?
}

struct InlineModel5: Codable {
  let WheelchairAccess: String?
  let download: TripRequestResponseJourneyLegStopDownload?
  let map: String?
  let area: Int?
  let platform: Int?
  let accessibility: InlineModel6?
}

struct RouteProduct: Codable {
  let line: InlineModel10?
  let network: InlineModel11?
}

struct InlineModel10: Codable {
  let id: String?
  let name: String?
}

struct InlineModel11: Codable {
  let id: String?
  let name: String?
}

struct TripRequestResponseJourneyLegInterchangeFrom: Codable {
  let track: String?
  let position: InlineModel12?
  let arrivalTimeEstimated: String?
  let arrivalTimePlanned: String?
  let arrivalTimeEstimatedPlatform: String?
  let arrivalTimePlannedPlatform: String?
}

struct InlineModel12: Codable {
  let direction: String?
  let position: InlineModel4?
}

struct TripRequestResponseJourneyLegInterchangeTo: Codable {
  let track: String?
  let position: InlineModel12?
  let departureTimeEstimated: String?
  let departureTimePlanned: String?
  let departureTimeEstimatedPlatform: String?
  let departureTimePlannedPlatform: String?
}

struct InlineModel15: Codable {
  let type: String?
  let value: String?
}

struct InlineModel16: Codable {
  let text: String?
  let type: String?
}

struct InlineModel17: Codable {
  let type: String?
  let value: String?
  let linkedObject: InlineModel18?
}

struct InlineModel18: Codable {
  let type: String?
  let id: String?
}

struct TripRequestResponseJourneyLegStopFootpathInfoFootpathElem: Codable {
  let start: TripRequestResponseJourneyLegStopFootpathInfoFootpathElemLocation?
  let destination: TripRequestResponseJourneyLegStopFootpathInfoFootpathElemLocation?
  let isStartStation: Bool?
  let isDestinationStation: Bool?
  let mode: String?
  let sbbOperator: String?
  let destinationText: String?
  let isRealtimeControlled: Bool?
}

struct InlineModel19: Codable {
  let message: String?
  let details: [InlineModel16]?
  let detailsAsText: String?
  let link: InlineModel17?
}

struct TripRequestResponseJourneyLegInterchangeFrom2: Codable {
  let track: String?
  let position: InlineModel12?
}

struct TripRequestResponseJourneyLegInterchangeTo2: Codable {
  let track: String?
  let position: InlineModel12?
}

struct InlineModel20: Codable {
  let type: String?
  let value: String?
  let message: String?
}

struct InlineModel21: Codable {
  let type: String?
  let value: String?
}

struct InlineModel22: Codable {
  let type: String?
  let value: String?
  let message: String?
}

struct InlineModel23: Codable {
  let type: String?
  let value: String?
}

struct InlineModel24: Codable {
  let type: String?
  let value: String?
  let link: InlineModel25?
}

struct InlineModel25: Codable {
  let type: String?
  let id: String?
}

struct InlineModel26: Codable {
  let type: String?
  let value: String?
  let link: InlineModel25?
}

struct InlineModel27: Codable {
  let type: String?
  let value: String?
  let message: String?
  let link: InlineModel28?
}

struct InlineModel28: Codable {
  let type: String?
  let id: String?
}

struct InlineModel29: Codable {
  let type: String?
  let value: String?
}

struct InlineModel30: Codable {
  let type: String?
  let value: String?
  let link: InlineModel31?
}

struct InlineModel31: Codable {
  let type: String?
  let id: String?
}
// swiftlint:enable discouraged_optional_boolean
