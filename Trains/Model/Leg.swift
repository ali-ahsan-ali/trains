//
//  Legs.swift
//  Trains
//
//  Created by Ali Ali on 5/8/2023.
//

import Foundation

class Leg: Identifiable {
    init(startTime: Date, endTime: Date, duration: TimeInterval = 0.0, from: Stop, to: Stop, intermediaryStops: [StopTimes], mode: Mode) {
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.from = from
        self.to = to
        self.intermediaryStops = intermediaryStops
        self.mode = mode
    }
    
    let id = UUID()
    let startTime: Date
    var endTime: Date
    var duration: TimeInterval = 0.0
    let from: Stop
    var to: Stop
    var intermediaryStops: [StopTimes]
    let mode: Mode
}

enum Mode {
    case walk
    case rail
    case unknown
}
