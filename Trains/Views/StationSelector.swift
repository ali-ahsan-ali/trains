//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import OpenTripPlannerApi

struct StationSelector: View {
    @ObservedObject var stationViewModel: StationListViewModel
    @State var fromStation: StationListQuery.Data.Station?
    @State private var searchText = ""
    @Binding var path: NavigationPath

    var body: some View {
        VStack {
            stationList()
        }
        .navigationBarTitle(fromStation == nil ? "From Station" : "To Station", displayMode: .inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear {
            stationViewModel.retreiveStations()
        }
    }

    var filteredStations: [String: [StationListQuery.Data.Station]] {
        if searchText.isEmpty {
            return stationViewModel.stations
        } else {
            var result: [String: [StationListQuery.Data.Station]] = [:]
            stationViewModel.stations.forEach { stationDict in
                let values = stationDict.value.filter { value in
                    value.name.localizedCaseInsensitiveContains(searchText)
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
                        ForEach(filteredStations[key] ?? [], id: \.id) { station in
                            if let fromStation = self.fromStation {
                                Button(
                                    "\(station.name)",
                                    action: {
                                        if !self.stationViewModel.tripViewModels.contains(where: { $0.fromStation.id == fromStation.id && $0.toStation.id == station.id }) {
                                            stationViewModel.addTrip(fromStop: fromStation, toStop: station)
                                            stationViewModel.saveTrips()
                                        }
                                        self.path = NavigationPath()
                                    }
                                )
                            } else {
                                NavigationLink(destination: StationSelector(stationViewModel: stationViewModel, fromStation: station, path: $path)) {
                                    VStack(alignment: .leading) {
                                        Text("\(station.name)")
                                    }
                                }
                            }
                        }
                    }.headerProminence(.increased)
                }
            }.listStyle(.plain)
            .clipped()
        }
    }
}

struct StationSelector_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        StationSelector(stationViewModel: StationListViewModel(), path: $path)
    }
}
