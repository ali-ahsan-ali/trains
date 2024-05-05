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
    var journeys: [TripRequestResponseJourney]?
    
    var firstDepartureTimeEstimated: Date {
        journeys?.first?.firstDepartureTimeEstimated ?? Date.now
    }
    
    var firstDepartureTimeEstimatedString: String {
        ISO8601DateFormatter().string(from: firstDepartureTimeEstimated)
    }
    
    var tripTimes: [TripTime] {
        journeys?.compactMap { $0.tripTime } ?? []
    }
}

struct ApiErrorResponse: Codable {
    let message: String?
}

struct TripRequestResponseJourney: Codable, Hashable {
    let legs: [TripRequestResponseJourneyLeg]?
    
    var firstDepartureTimeEstimated: Date {
        legs?.first?.origin?.departureTimeEstimatedDate ?? Date.distantPast
    }
    
    var firstArrivalTimeEstimatedDate: Date {
        legs?.last?.destination?.arrivalTimeEstimatedDate ?? Date.distantPast
    }
    
    var tripTime: TripTime? {
        guard let first = legs?.first?.origin?.departureTimeEstimatedDate, let last = legs?.last?.destination?.arrivalTimeEstimatedDate else {
            return nil
        }
        return TripTime(startTime: first, endTime: last)
    }
    
    var legsDescription: String {
        guard let legs else { return  "" }
        var legsMapped: [String] = []
        for leg in legs {
            legsMapped.append(leg.iconId)
        }
        return legsMapped.joined(separator: "->")
    }
}

struct TripRequestResponseJourneyLeg: Codable, Hashable {
    let duration: Int?
    let distance: Int?
    let origin: TripRequestResponseJourneyLegStop?
    let destination: TripRequestResponseJourneyLegStop?
    let transportation: TripTransportation?
    
    var iconId: String {
        transportation?.mappedId ?? "Other"
    }
}

struct TripTransportation: Codable, Hashable {
    let iconId: Int?
    
    var mappedId: String {
        switch iconId {
        case 1: "Sydney Trains"
        case 2: "Intercity Trains"
        case 3: "Regional Trains"
        case 19: "Temporary Trains"
        case 24: "Sydney Metro"
        case 13: "Sydney Light Rail"
        case 20: "Temporary Light Rail"
        case 21: "Newcastle Light Rail"
        case 4: "Blue Mountains Buses"
        case 5: "Sydney Buses"
        case 6: "Central Coast Buses"
        case 14: "Temporary Buses"
        case 15: "Hunter Buses"
        case 23: "On Demand"
        case 31: "Central West and Orana"
        case 32: "Far West"
        case 33: "New England North West"
        case 34: "Newcastle and Hunter"
        case 35: "North Coast"
        case 36: "Riverina Murray"
        case 37: "South East and Tablelands"
        case 38: "Sydney and Surrounds"
        case 9: "Private Buses"
        case 17: "Private Coaches"
        case 7: "Regional Coaches"
        case 22: "Temporary Coaches"
        case 10: "Sydney Ferries"
        case 11: "Newcastle Ferries"
        case 12: "Private Ferries"
        case 18: "Temporary Ferries"
        case 8: "School Buses"
        default: "Other"
        }
    }
}

struct TripRequestResponseJourneyLegStop: Codable, Hashable {
    let arrivalTimeEstimated: String?
    let arrivalTimePlanned: String?
    let departureTimeEstimated: String?
    let departureTimePlanned: String?
    let id: String
    let name: String
    let infos: TripRequestResponseJourneyLegStopInfo?
    
    var departureTimeEstimatedDate: Date {
        ISO8601DateFormatter().date(from: departureTimeEstimated ?? "") ?? Date.distantPast
    }
    
    var arrivalTimeEstimatedDate: Date {
        ISO8601DateFormatter().date(from: arrivalTimeEstimated ?? "") ?? Date.distantPast
    }
}

struct TripRequestResponseJourneyLegStopInfo: Codable, Hashable {
    let content: String
    let subtitle: String
    let priority: String
}
