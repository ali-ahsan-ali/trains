//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import SwiftData
import ActivityKit
import LiveTrainsExtension
import FirebaseFirestore

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
    @State private var tripViewModels: [String: TripViewModel] = [:]

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
            }.onChange(of: trips, initial: true) { _, newValue in
                newValue.forEach { trip in
                    if tripViewModels[trip.id] == nil {
                        tripViewModels[trip.id] = TripViewModel(trip: trip)
                    }
                }
            }
            .onChange(of: favouriteTrip, initial: true) { _, _ in
                guard let favouriteTrip = favouriteTrip else { return }
                let favouriteDict = [
                    "startStopId": favouriteTrip.startStop.stopId,
                    "startStopName": favouriteTrip.startStop.stopNameWithoutStation,
                    "endStopId": favouriteTrip.endStop.stopId,
                    "endStopName": favouriteTrip.endStop.stopNameWithoutStation
                ]
                let userIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? ""
                Task {
                    do {
                        try await Firestore.firestore().collection("pushTokens").document(userIdentifier).setData(["favouriteTrip": favouriteDict], merge: true)
                    } catch {
                        TrainLogger.network.error("\(error)")
                    }
                }
            }
            .listStyle(.plain)
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
                    let isDefactoFavourite = favouriteTrip?.id == trip.id
                    TripView(trip: trip, isDefactoFavourite: isDefactoFavourite)
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
    
    var favouriteTrip: Trip? {
        return trips.first(where: { $0.favourite }) ?? trips.first
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
