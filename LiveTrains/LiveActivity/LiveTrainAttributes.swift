//
//  LiveTrainAttributes.swift
//  Trains
//
//  Created by Ali Ali on 22/2/2024.
//

import Foundation
import ActivityKit

struct LiveTrainsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var times: [TripTime]
    }

    // Fixed non-changing properties about your activity go here!
    var startStopName: String
    var endStopName: String
}
