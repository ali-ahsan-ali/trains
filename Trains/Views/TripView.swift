//
//  TripRowView.swift
//  Trains
//
//  Created by Ali Ali on 12/2/2024.
//

import SwiftUI
import ActivityKit
import LiveTrainsExtension

struct TripView: View {
    let viewModel: TripViewModel
    init (trip: Trip){
        viewModel = TripViewModel(trip: trip)
    }
    var body: some View {
        VStack{
            if !viewModel.tripTimes.isEmpty {
                List(viewModel.tripTimes, id:\.self){ tripTimes in
                    VStack{
                        HStack{
                            Text("Departure time: ")
                            Text(tripTimes.startTime, style: .time)
                        }
                        HStack{
                            Text("Arrival time: ")
                            Text(tripTimes.endTime, style: .time)
                        }
                    }
                }.onChange(of: viewModel.tripTimes, initial: true){ oldValue, newValue  in
                    guard viewModel.trip.favourite == true else { return }
                    /// If empty and activity started, close
                    /// If not empty and no activity started, start activity
                    /// If not empty and activity already started, update
                    if newValue.isEmpty, viewModel.currentActivity != nil {
                        Task {
                            await viewModel.currentActivity?.end(.none, dismissalPolicy: .immediate)
                        }
                    } else if !newValue.isEmpty {
                        if viewModel.currentActivity == nil {
                            viewModel.startLiveActivity(tripTimes: newValue)
                        } else {
                            Task {
                                await viewModel.updateTrips(times: newValue)
                            }
                        }
                    }
                }
            } else if let error = viewModel.tripError{
                Text("\(error)")
            } else {
                VStack {
                    List(0...10, id:\.self){_ in
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

