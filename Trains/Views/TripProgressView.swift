//
//  TripProgressView.swift
//  Trains
//
//  Created by Ali Ali on 26/2/2024.
//

import SwiftUI

struct TripProgressView: View {

    let viewModels: [ProgressBarViewModel]
    let tripAttributes: LiveTrainsAttributes

    init (tripAttributes: LiveTrainsAttributes, tripTimes: LiveTrainsAttributes.ContentState) {
        self.tripAttributes = tripAttributes
        viewModels = tripTimes.times.prefix(3).map { tripTime in
            ProgressBarViewModel(arrivalTime: tripTime.startTime)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModels, id: \.self) { viewModel in
                HStack(alignment: .bottom) {
                    TimeProgressView(viewModel: viewModel)
                    Text(timerInterval: viewModel.tripTime)
                        .font(.caption)
                        .frame(width: 35)
                }
            }
        }
    }
}
#Preview {
    TripProgressView(
        tripAttributes: LiveTrainsAttributes(
            startStopName: "Pymble",
            endStopName: "Redfern"
        ),
        tripTimes: LiveTrainsAttributes.ContentState(
            times: [
                TripTime(
                    startTime: Date.now.addingTimeInterval(500),
                    endTime: Date.now.addingTimeInterval(16)
                ),
                TripTime(
                    startTime: Date.now.addingTimeInterval(900),
                    endTime: Date.now.addingTimeInterval(30)
                ),
                TripTime(
                    startTime: Date.now.addingTimeInterval(800),
                    endTime: Date.now.addingTimeInterval(1412)
                )
            ]
        )
    )
}
