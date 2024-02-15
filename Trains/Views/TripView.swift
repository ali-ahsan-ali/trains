//
//  TripRowView.swift
//  Trains
//
//  Created by Ali Ali on 12/2/2024.
//

import SwiftUI

struct TripView: View {
    let viewModel: TripViewModel
    
    var body: some View {
        VStack{
            if let journeys = viewModel.trips?.journeys {
                List(journeys, id:\.self){ journey in
                    VStack{
                        HStack{
                            Text("Departure time: ")
                            Text(journey.departureTimeEstimated, style: .time)
                        }
                        HStack{
                            Text("Arrival time: ")
                            Text(journey.arrivalTimeEstimatedDate, style: .time)
                        }
                        Text(journey.legsDescription)
                    }
                }
            } else {
                Text("No trips available :(")
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(viewModel.startStop.stopName) -> \(viewModel.endStop.stopName)")
    }
}

