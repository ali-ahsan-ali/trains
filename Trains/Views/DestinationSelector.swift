//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import GTFS

struct DestinationSelector: View {
    @ObservedObject var stationViewModel: StationListViewModel
    @State private var searchText = ""
    @Binding var path: NavigationPath

    var body: some View {
        VStack {
            stationList()
        }
        .navigationBarTitle("To Station", displayMode: .inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            stationViewModel.retreiveStations()
        }
    }

    var filteredStations: [String: [Stop]] {
        if searchText.isEmpty {
            return stationViewModel.stations
        } else {
            var result: [String: [Stop]] = [:]
            stationViewModel.stations.forEach { stationDict in
                let values = stationDict.value.filter { value in
                    value.stopName.localizedCaseInsensitiveContains(searchText)
                }
                if !values.isEmpty {
                    result[stationDict.key] = values
                }
            }
            return result
        }
    }

    @ViewBuilder
    func stationList() -> some View {
        if stationViewModel.stations.isEmpty && stationViewModel.isError == false {
            Text("Loading...")
        } else if stationViewModel.isError == true, let error = stationViewModel.appAlert {
            Text(error)
        } else {
            List {
                ForEach(filteredStations.keys.sorted(), id: \.self) { key in
                    Section(header: Text("\(key)")) {
                        ForEach(filteredStations[key] ?? [], id: \.stopId) { station in
                            Button(
                                "\(station.stopName)",
                                action: {
                                    if !self.stationViewModel.savedDestinationStations.contains(where: { $0.destination.stopId == station.stopId }) {
                                        stationViewModel.appendDestination(station)
                                        stationViewModel.saveDestinationStations()
                                    }
                                    self.path = NavigationPath()
                                }
                            )
                        }
                    }.headerProminence(.increased)
                }
            }.listStyle(.plain)
            .clipped()
        }
    }
}

struct DestinationSelector_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DestinationSelector(stationViewModel: StationListViewModel(), path: $path)
    }
}
