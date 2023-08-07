//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import OpenTripPlannerApi

struct ContentView: View {
    init() { // swiftlint:disable:this type_contents_order
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
    }

    @StateObject var stationViewModel = StationListViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                NavigationLink("Add Trip", value: "From Station")
                .navigationDestination(for: String.self) { _ in
                    StationSelector(stationViewModel: stationViewModel, path: $path)
                }
                List {
                    ForEach(stationViewModel.tripViewModels, id: \.id) { tripViewModel in
                        NavigationLink(destination: TripTimeView(tripTimeViewModel: TripTimeViewModel(tripViewModel: tripViewModel))) {
                            Text("\(tripViewModel.fromStation.name) -> \(tripViewModel.toStation.name)")
                        }
                    }
                }.listStyle(.plain)
            }
            .navigationBarTitle("Trips")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
