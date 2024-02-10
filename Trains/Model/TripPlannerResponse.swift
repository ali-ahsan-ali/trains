//
//  TripPlannerResponse.swift
//  Trains
//
//  Created by Ali, Ali on 15/8/2023.
//

import Foundation

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
    let infos: TripRequestResponseJourneyLegStopInfo?
}

struct TripRequestResponseJourneyLegStopInfo: Codable {
    let content: String
    let subtitle: String
    let priority: String
}
