//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import SwiftData

struct StationSelector: View {
    @Environment(\.modelContext) 
    private var modelContext
    
    @Query var allTrips: [Trip]
    
    var viewModel: StationListViewModel
    @Binding var path: NavigationPath
    @State var startingStop: Stop?
    @State private var searchText = ""

    var body: some View {
        VStack {
            stationList()
        }
        .navigationBarTitle(startingStop == nil ? "From Station" : "To Station", displayMode: .inline)
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

    @MainActor 
    @ViewBuilder
    func stationList() -> some View {
        if viewModel.shouldShowAlert == true {
            Text(viewModel.alertMessage)
        } else {
            List {
                ForEach(filteredStations.keys.sorted(), id: \.self) { key in
                    Section(header: Text("\(key)")) {
                        ForEach(filteredStations[key] ?? [], id: \.stopId) { station in
                            Button {
                                if let startingStop {
                                    modelContext.insert(Trip(startStop: startingStop, endStop: station))
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        TrainLogger.stops.error("\(error)")
                                    }
                                    self.path = NavigationPath()
                                } else {
                                    path.append(Destinations.stationSelector(station: station))
                                }
                            } label: {
                                HStack {
                                    Text(station.stopName)
                                    Spacer()
                                    Image(systemName: "chevron.right")
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

#Preview {
    @State var path = NavigationPath()
    path.append(Destinations.stationSelector(station: nil))
    return NavigationStack {
        StationSelector(viewModel: StationListViewModel(), path: $path)
            .modelContainer(previewContainer)
    }
}
