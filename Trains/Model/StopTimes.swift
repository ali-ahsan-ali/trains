//
//  StopTimes.swift
//  Trains
//
//  Created by Ali Ali on 7/8/2023.
//

import Foundation

struct StopTimes: Identifiable {
    let id = UUID()
    let stop: Stop
    let arrival: Date
    let departure: Date
}
