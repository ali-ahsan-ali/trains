//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import SwiftData
import ActivityKit
//import LiveTrainsExtension

enum Destinations: Hashable {
    case stationSelector(station: Stop?)
    case tripView(trip: Trip)
    case individualTripView
}

struct ContentView: View {
    @Environment(\.modelContext) 
    private var modelContext
    
    init() {
        Task { @MainActor in
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        }
    }

    @State var stationViewModel = StationListViewModel()
    @State private var path = NavigationPath()
    @Query var trips: [Trip]
    @State private var hasAppeared = false
    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(trips) { trip in
                    NavigationLink(value: Destinations.tripView(trip: trip)) {
                        tripRow(trip: trip)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet.reversed() {
                        deleteTrip(trips[index])
                    }
                }
            }            .listStyle(.plain)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add Trip", value: Destinations.stationSelector(station: nil))
                }
            }
            .navigationBarTitle("Trips")
            .navigationDestination(for: Destinations.self) { destination in
                switch destination {
                case .stationSelector(station: let stop):
                    StationSelector(viewModel: stationViewModel, path: $path, startingStop: stop)
                case .tripView(trip: let trip):
                    TripView(trip: trip)
                case .individualTripView:
                    EmptyView()
                }
            }
        }
        .alert(alertMessage, isPresented: $alert, actions: {
            Button {
                alert = false
            } label: {
                Text("OK")
            }
        })
    }
    
    func deleteTrip(_ trip: Trip) {
        withAnimation {
            modelContext.delete(trip)
            do {
                try modelContext.save()
            } catch {
                TrainLogger.stops.error("\(error)")
                alert = true
                alertMessage = "Error deleting trip"
            }
        }
    }
    
    @ViewBuilder
    func tripRow(trip: Trip) -> some View {
        HStack {
            Text("\(trip.startStop.stopName.replacingOccurrences(of: "Station", with: ""))")
                .font(.title2)
            Spacer()
            Text("\(trip.endStop.stopName.replacingOccurrences(of: "Station", with: ""))")
                .font(.title2)
            Image(systemName: trip.favourite ? "star.fill" : "star")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(trip.favourite ? .yellow : .gray)
                .onTapGesture {
                    trips.forEach { trip in
                        trip.favourite = false
                    }
                    trip.favourite.toggle()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
