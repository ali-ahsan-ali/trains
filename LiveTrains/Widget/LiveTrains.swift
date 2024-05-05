//
//  LiveTrains.swift
//  LiveTrains
//
//  Created by Ali Ali on 14/2/2024.
//

import WidgetKit
import SwiftUI
import SwiftData
import ActivityKit
import FirebaseFirestore

struct Provider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        TrainLogger.stops.debug("placeholder")

        return SimpleEntry(
            date: Date.now,
            configuration: ConfigurationAppIntent(),
            arrivalTime: Date.now,
            departureStop: Stop(stopId: "1", stopName: "Pymble"),
            arrivalStop: Stop(stopId: "1", stopName: "Central")
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        TrainLogger.stops.debug("snapshot")
        return SimpleEntry(
            date: Date.now,
            configuration: configuration,
            arrivalTime: Date.now,
            departureStop: Stop(stopId: "1", stopName: "Pymble"),
            arrivalStop: Stop(stopId: "1", stopName: "Central")
        )
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let trip = await getFavouriteTrip()
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        guard let trip else {
            TrainLogger.stops.debug("No Trip")
            return Timeline(entries: [], policy: .atEnd)
        }
        await trip.retrieveTrip()
        guard let tripTime = trip.tripTimes.first else {
            TrainLogger.stops.debug("No Trip Times")
            return Timeline(entries: [], policy: .atEnd)
        }

//        let entries: [SimpleEntry] = journeys.map { journey in
//            let entry = SimpleEntry(
//                date: tripTime.startTime,
//                configuration: configuration,
//                arrivalTime: tripTime.startTime,
//                departureStop: trip.trip.startStop,
//                arrivalStop: trip.trip.endStop
//            )
//            return entry
//        }
//        TrainLogger.stops.debug("Timelines: First \(entries[0].formattedDate)")
//        TrainLogger.stops.debug("Second \(entries[1].formattedDate)")
        return Timeline(entries: [], policy: .atEnd)
    }

    @MainActor
    private func getFavouriteTrip() async -> TripViewModel? {
        guard let container = try? ModelContainer(for: Trip.self, Stop.self) else {
            TrainLogger.stops.debug("Empty Container")
            return nil
        }
        let descriptor = FetchDescriptor<Trip>(predicate: #Predicate { trip in
            trip.favourite == true
        })
        guard let trip =  try? container.mainContext.fetch(descriptor).first else {
            guard let firstTrip = try? container.mainContext.fetch(FetchDescriptor<Trip>()).first else {
                return nil
            }
            return TripViewModel(trip: firstTrip)
        }
        return TripViewModel(trip: trip)

    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let arrivalTime: Date
    let departureStop: Stop
    let arrivalStop: Stop

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var formattedDate: String {
        formatter.string(from: date)
    }

    var formattedArrivalDate: String {
        formatter.string(from: arrivalTime)
    }
}

struct LiveTrainsEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
                Text("\(entry.departureStop.stopName)")
                Text("Arrival Stop: \(entry.arrivalStop.stopName)")
            HStack {
                Text("Departure Time: \(entry.formattedDate)")
                Text("Arrival Time: \(entry.formattedArrivalDate)")
            }
            Button(intent: ReloadWidgetIntent()) {
                Text("Refresh")
            }
        }
    }
}

import AppIntents

struct ReloadWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Reload widget"
    static var description = IntentDescription("Reload widget.")

    func perform() async throws -> some IntentResult {
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct LiveTrains: Widget {
    let kind: String = "LiveTrains"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LiveTrainsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
