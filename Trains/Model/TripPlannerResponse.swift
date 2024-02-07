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
  let journeys: [TripRequestResponseJourney]?
}

struct ApiErrorResponse: Codable {
  let message: String?
}

struct TripRequestResponseJourney: Codable {
  let legs: [TripRequestResponseJourneyLeg]?
}

struct TripRequestResponseJourneyLeg: Codable {
  let duration: Int?
  let distance: Int?
  let origin: TripRequestResponseJourneyLegStop?
  let destination: TripRequestResponseJourneyLegStop?
}

struct TripRequestResponseJourneyLegStop: Codable {
    let arrivalTimeEstimated: String?
    let arrivalTimePlanned: String?
    let departureTimeEstimated: String?
    let departureTimePlanned: String?
    let id: String
    let name: String
}

// swiftlint:enable discouraged_optional_boolean
