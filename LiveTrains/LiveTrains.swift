//
//  LiveTrains.swift
//  LiveTrains
//
//  Created by Ali Ali on 14/2/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    @MainActor
    func placeholder(in context: Context) -> SimpleEntry {
        TrainLogger.stops.debug("placeholder")

        return SimpleEntry(date: Date.now, configuration: ConfigurationAppIntent(), arrivalTime: Date.now, departureStop: Stop(stopId: "1", stopName: "Pymble"), arrivalStop: Stop(stopId: "1", stopName: "Central"))
    }

    @MainActor
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        TrainLogger.stops.debug("snapshot")
        return SimpleEntry(date: Date.now, configuration: configuration, arrivalTime: Date.now, departureStop: Stop(stopId: "1", stopName: "Pymble"), arrivalStop: Stop(stopId: "1", stopName: "Central"))
    }
    
    @MainActor
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let trips = getTrips()
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        guard let firstTrip = trips.first, let journeys = try? await firstTrip.retreiveTripDetails().journeys, !journeys.isEmpty else {
            TrainLogger.stops.debug("No Journeys")
            return Timeline(entries: [], policy: .atEnd)
        }
        let entries: [SimpleEntry] = journeys.map{ journey in
            let entry = SimpleEntry(date: journey.departureTimeEstimated, configuration: configuration, arrivalTime: journey.arrivalTimeEstimatedDate, departureStop: firstTrip.startStop, arrivalStop: firstTrip.endStop)
            return entry
        }
        TrainLogger.stops.debug("Timelines: First \(entries[0].formattedDate)")
        TrainLogger.stops.debug("Second \(entries[1].formattedDate)")
        return Timeline(entries: entries, policy: .after(entries[0].date))
    }
    
    @MainActor
    private func getTrips() -> [TripViewModel] {
        guard let container = try? ModelContainer(for: TripViewModel.self, Stop.self) else {
            TrainLogger.stops.debug("Empty Container")
            return []
        }
        let descriptor = FetchDescriptor<TripViewModel>()
        let trips =  try? container.mainContext.fetch(descriptor)
        return trips ?? []
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

struct LiveTrainsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
                Text("\(entry.departureStop.stopName)")
                Text("Arrival Stop: \(entry.arrivalStop.stopName)")
            HStack{
                Text("Departure Time: \(entry.formattedDate)")
                Text("Arrival Time: \(entry.formattedArrivalDate)")
            }
        }
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
