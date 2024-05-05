//
//  TrainsApp.swift
//  Trains
//
//  Created by Ali Ali on 11/6/2023.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct TrainsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) 
    var appDelegate

    let container: ModelContainer = {
        do {
            return try ModelContainer(for: Trip.self, Stop.self, configurations: ModelConfiguration())
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
