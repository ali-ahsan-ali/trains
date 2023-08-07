//
//  Plan.swift
//  Trains
//
//  Created by Ali Ali on 5/8/2023.
//

import Foundation

class Plan: Identifiable {
    init(startTime: Date, endTime: Date, duration: TimeInterval) {
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
    }
    let id = UUID()
    let startTime: Date
    var endTime: Date
    var duration: TimeInterval = 0.0
    var legs: [Leg] = []
}
