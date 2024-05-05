//
//  Trips.swift
//  Trains
//
//  Created by Ali Ali on 12/2/2024.
//

import Foundation
import SwiftData

@Model
final class Trip: Equatable, Hashable, Sendable {
    @Attribute(.unique) 
    let id: String
    
    var startStop: Stop
    var endStop: Stop
    var created: Date
    var favourite: Bool
    var lastRefreshedTime: Date
    
    init(startStop: Stop, endStop: Stop, favourite: Bool = false) {
        self.startStop = startStop
        self.endStop = endStop
        self.created = Date.now
        self.favourite = favourite
        self.id = startStop.stopId + endStop.stopId
        self.lastRefreshedTime = Date.distantPast
    }
}
