//
//  TripViewModel.swift
//  Trains
//
//  Created by Ali, Ali on 30/7/2023.
//

import Foundation
import OpenTripPlannerApi

struct TripViewModel: Codable {
    let id = UUID()
    let fromStation: Station
    let toStation: Station
}
