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
            TrainProgressLegend()
            VStack(alignment: .center, spacing: 0) {
                ForEach(viewModels, id: \.self) { viewModel in
                    HStack {
                        Text("Arriving at \(tripAttributes.startStop.stopNameWithoutStation) in:")
                            .font(.caption)
                        Text(timerInterval: viewModel.tripTime)
                            .font(.caption)
                    }.border(.red)
                    TimeProgressView(viewModel: viewModel).border(.blue)
                }
            }
            .padding()
        }
    }
}
#Preview {
    TripProgressView(
        tripAttributes: LiveTrainsAttributes(
            startStop: Stop(stopId: "1", stopName: "Pymble"),
            endStop: Stop(stopId: "1", stopName: "Redfern")
        ),
        tripTimes: LiveTrainsAttributes.ContentState(
            times: [
                TripTime(
                    startTime: Date.now.addingTimeInterval(18),
                    endTime: Date.now.addingTimeInterval(16)
                ),
                TripTime(
                    startTime: Date.now.addingTimeInterval(31),
                    endTime: Date.now.addingTimeInterval(30)
                ),
                TripTime(
                    startTime: Date.now.addingTimeInterval(50),
                    endTime: Date.now.addingTimeInterval(1412)
                )
            ]
        )
    )
}
