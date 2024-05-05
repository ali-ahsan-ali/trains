//
//  Logger.swift
//  Trains
//
//  Created by Ali, Ali on 5/8/2023.
//

import OSLog

class TrainLogger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static let subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

    /// All logs related to stops.
    static let stops = Logger(subsystem: subsystem, category: "stops")

    /// All logs related to tracking and analytics.
    static let network = Logger(subsystem: subsystem, category: "network")
    
    static let activity = Logger(subsystem: subsystem, category: "activity")
}
