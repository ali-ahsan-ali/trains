//
//  TripRowView.swift
//  Trains
//
//  Created by Ali Ali on 12/2/2024.
//

import SwiftUI
@preconcurrency import ActivityKit
import LiveTrainsExtension

struct TripView: View {
    let viewModel: TripViewModel
    let isDefactoFavourite: Bool
    
    init (trip: Trip, isDefactoFavourite: Bool = false) {
        viewModel = TripViewModel(trip: trip)
        self.isDefactoFavourite = isDefactoFavourite
    }
    
    var body: some View {
        VStack {
            
            Button("End") {
                Task { @MainActor in
                    await ActivityManager.actor.endActivity()
                }
            }
        
            if !viewModel.tripTimes.isEmpty, viewModel.tripTimes.last?.startTime ?? Date.distantFuture > Date.now {
                List(viewModel.tripTimes, id: \.self) { tripTimes in
                    VStack {
                        HStack {
                            Text("Departure time: ")
                            Text(tripTimes.startTime, style: .time)
                        }
                        HStack {
                            Text("Arrival time: ")
                            Text(tripTimes.endTime, style: .time)
                        }
                    }
                }.onChange(of: viewModel.tripTimes, initial: true) { _, newValue  in
                    guard viewModel.trip.favourite == true || isDefactoFavourite else { return }
                    /// If empty and activity started, close
                    /// If not empty and no activity started, start activity
                    /// If not empty and activity already started, update
                    if newValue.isEmpty {
                        Task { @MainActor in
                            await ActivityManager.actor.endActivity()
                        }
                    } else if !newValue.isEmpty {
                        if ActivityManager.actor.currentActivity == nil {
                            Task { @MainActor in
                                try await ActivityManager.actor.startActivity(startStop: viewModel.trip.startStop, endStop: viewModel.trip.endStop, tripTimes: newValue)
                            }
                        } else {
                            Task { @MainActor in
                                await ActivityManager.actor.updateActivity(state: LiveTrainsAttributes.ContentState(times: newValue))
                            }
                        }
                    }
                }.onAppear {
                    // If defacto favourite then set as favourite
                    if isDefactoFavourite {
                        viewModel.trip.favourite = isDefactoFavourite
                    }
                }
            } else if let error = viewModel.tripError {
                Text("\(error)")
            } else {
                VStack {
                    List(0...10, id: \.self) { _ in
                        Shimmer()
                            .frame(height: 40)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(viewModel.trip.startStop.stopName) -> \(viewModel.trip.endStop.stopName)")
    }
}
