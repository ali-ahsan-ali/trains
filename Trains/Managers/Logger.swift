//
//  Logger.swift
//  Trains
//
//  Created by Ali, Ali on 5/8/2023.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

    /// All logs related to tracking and analytics.
    static let network = Logger(subsystem: subsystem, category: "network")
}
