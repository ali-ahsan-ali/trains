//
//  PreviewContainer.swift
//  Trains
//
//  Created by Ali Ali on 10/2/2024.
//

import SwiftUI
import SwiftData

@MainActor let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Trip.self, configurations: ModelConfiguration())
        try StopManager.retreiveStations().values.forEach { stops in
            for stop in stops {
                container.mainContext.insert(Trip(startStop: stop, endStop: stop))
            }
        }
        return container
    } catch {
        fatalError("DEATH")
    }
}()
