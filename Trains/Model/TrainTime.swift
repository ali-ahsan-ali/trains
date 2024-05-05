//
//  TrainTime.swift
//  Trains
//
//  Created by Ali Ali on 22/2/2024.
//

import Foundation

public struct TripTime: Codable, Hashable, Sendable {    
    let startTime: Date
    let endTime: Date
}
