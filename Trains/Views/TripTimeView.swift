//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import OpenTripPlannerApi
import Combine

struct TripTimeView: View {
    let network = Network.shared
    @ObservedObject var tripTimeViewModel: TripTimeViewModel
    @State private var timer: AnyCancellable?

    var body: some View {
        VStack {
            tripTimes()
        }.onAppear {
            tripTimeViewModel.createWatcher()
            tripTimeViewModel.watcher?.refetch()
            startTimer()
        }.onDisappear {
            tripTimeViewModel.watcher?.cancel()
        }.navigationBarTitle("\(tripTimeViewModel.tripViewModel.fromStation.name) to \(tripTimeViewModel.tripViewModel.toStation.name)", displayMode: .inline)
    }
    
    func startTimer() {
        timer = Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                tripTimeViewModel.watcher?.refetch()
            }
    }
    
    @ViewBuilder
    func tripTimes() -> some View {
        if !tripTimeViewModel.tripTimes.isEmpty {
            List(tripTimeViewModel.tripTimes) { trip in
                NavigationLink(destination: TripView()) {
                    Text("\(trip.startTime.hourMinuteString) -> \(trip.endTime.hourMinuteString)")
                }
            }
            if tripTimeViewModel.isError == true, let error = tripTimeViewModel.appAlert {
                Text(error)
            }
        } else if tripTimeViewModel.isError == true, let error = tripTimeViewModel.appAlert {
            Text(error)
        } else {
            Text("Loading")
        }
    }
}

private extension Date {
    var hourMinuteString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_AU")
        return dateFormatter.string(from: self)
    }
}
