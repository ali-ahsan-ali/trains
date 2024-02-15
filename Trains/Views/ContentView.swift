//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import SwiftData

enum Destinations: Hashable {
    case stationSelector(station: Stop?)
    case tripView(viewModel: TripViewModel)
    case individualTripView
}

struct ContentView: View {
    init() { // swiftlint:disable:this type_contents_order
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
    }
    @Environment(\.modelContext) private var modelContext

    @State var stationViewModel = StationListViewModel()
    @State private var path = NavigationPath()
    @Query var trips: [TripViewModel]
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                ForEach(trips) { tripViewModel in
                    NavigationLink(value: Destinations.tripView(viewModel: tripViewModel)) {
                        tripRow(trip: tripViewModel)
                            .task {
                                do {
                                    tripViewModel.trips = try await tripViewModel.retreiveTripDetails()
                                    TrainLogger.stops.debug("\(tripViewModel.trips.debugDescription)")
                                } catch {
                                    tripViewModel.tripError = "Error: \(error)"
                                }
                            }
                    }
                }
            }
            .listStyle(.plain)
            .headerProminence(.increased)
            .toolbar {
                NavigationLink("Add Trip", value: Destinations.stationSelector(station: nil))
                    .navigationDestination(for: Destinations.self) { destination in
                        switch destination {
                        case .stationSelector(station: let stop):
                            StationSelector(viewModel: stationViewModel, path:$path , startingStop: stop)
                        case .tripView(viewModel: let tripViewModel):
                            TripView(viewModel: tripViewModel)
                        case .individualTripView:
                            EmptyView()
                        }
                    }
                    .navigationBarTitle("Trips")
            }
        }
    }
    
    @ViewBuilder
    func firstLineTripRow(trip: TripViewModel) -> some View {
        HStack{
            Text("\(trip.startStop.stopName)")
            Spacer()
            Text("\(trip.endStop.stopName)")
        }
    }
    
    @ViewBuilder
    func tripRow(trip: TripViewModel) -> some View {
        VStack{
            firstLineTripRow(trip: trip)
            HStack{
                if let error = trip.tripError {
                    Text(error)
                } else if let tripResponse = trip.trips {
                    Text(tripResponse.journeys?.first?.legs?.first?.origin?.departureTimeEstimatedDate ?? Date.distantPast, style: .time)
                    Spacer()
                    Text(tripResponse.journeys?.first?.legs?.last?.destination?.arrivalTimeEstimatedDate ?? Date.distantPast, style: .time)
                } else {
                    ProgressView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
