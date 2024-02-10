//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct ContentView: View {
    init() { // swiftlint:disable:this type_contents_order
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
    }

    @State var stationViewModel = StationListViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("HUH")
//                List(stationViewModel.stations) { destinationViewModel in
//                    Text("\(destinationViewModel.destination.stopName)")
//                        .font(.title2)
//                        .onAppear {
//                            destinationViewModel.retreiveTripDetails()
//                        }
//                }
//                .listStyle(.plain)
//                .headerProminence(.increased)
                .toolbar {
                    NavigationLink("Add Trip", value: "From Station")
                    .navigationDestination(for: String.self) { _ in
                        DestinationSelector(viewModel: stationViewModel, path: $path)
                    }
                }
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
