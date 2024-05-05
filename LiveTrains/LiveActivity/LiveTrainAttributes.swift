//
//  LiveTrainAttributes.swift
//  Trains
//
//  Created by Ali Ali on 22/2/2024.
//

import Foundation
import ActivityKit

struct LiveTrainsAttributes: ActivityAttributes, Sendable, Codable {
    public struct ContentState: Codable, Hashable, Sendable {
        // Dynamic stateful properties about your activity go here!
        var times: [TripTime]
    }

    // Fixed non-changing properties about your activity go here!
    var startStop: Stop
    var endStop: Stop
}

extension LiveTrainsAttributes: CustomDebugStringConvertible {
    var debugDescription: String {
        startStopName + " " + endStopName
    }
    
    var startStopName: String {
        startStop.stopNameWithoutStation
    }
   
    var endStopName: String {
        endStop.stopNameWithoutStation
    }
}
