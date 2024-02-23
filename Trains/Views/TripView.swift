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
            if let tripTimes = viewModel.tripTimes {
                List(tripTimes, id:\.self){ tripTimes in
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
                }.onAppear{
                    guard let tripTimes = viewModel.tripTimes, viewModel.trip.favourite == true else { return }
                    viewModel.startLiveActivity(tripTimes: tripTimes)
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

