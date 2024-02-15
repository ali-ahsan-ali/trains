//
//  TrainsApp.swift
//  Trains
//
//  Created by Ali Ali on 11/6/2023.
//

import SwiftUI
import SwiftData

@main
struct TrainsApp: App {
    public let container: ModelContainer = {
        do {
            return try ModelContainer(for: TripViewModel.self, Stop.self, configurations: ModelConfiguration())
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
