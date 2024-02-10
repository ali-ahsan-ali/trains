//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import SwiftData

struct DestinationSelector: View {    
//    @Environment(\.modelContext) private var modelContext
    @State var viewModel: StationListViewModel
    @State private var startingStop: Stop?
    @Binding var path: NavigationPath
    @State private var searchText = ""

    var body: some View {
        VStack {
            stationList()
        }
        .navigationBarTitle("To Station", displayMode: .inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }

    var filteredStations: [String: [Stop]] {
        if searchText.isEmpty {
            return viewModel.stops
        } else {
            var result: [String: [Stop]] = [:]
            viewModel.stops.forEach { stationDict in
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
        if viewModel.shouldShowAlert == true {
            Text(viewModel.alertMessage)
        } else {
            List {
                ForEach(filteredStations.keys.sorted(), id: \.self) { key in
                    Section(header: Text("\(key)")) {
                        ForEach(filteredStations[key] ?? [], id: \.stopId) { station in
                            Button(
                                station.stopName,
                                action: {
                                    if startingStop == nil {
                                        path.append("To Stations")
                                        return
                                    } else {
                                        if !viewModel.trips.contains {$0.startStop == startingStop && $0.endStop == station} {
                            //                modelContext.insert(TripViewModel(startStop: startingStop, endStop: station))
                                        }
                                        self.path = NavigationPath()
                                    }
                                }
                            ).navigationDestination(for: String.self) { path in
                                if path == "To Stations" {
                                    DestinationSelector(viewModel: viewModel, startingStop: station, path: $path)
                                } else {
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .listStyle(.plain)
            .clipped()
        }
    }
}

struct DestinationSelector_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        DestinationSelector(viewModel: StationListViewModel(), path: $path)
    }
}
