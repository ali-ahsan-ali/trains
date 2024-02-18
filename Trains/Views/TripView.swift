//
//  TripRowView.swift
//  Trains
//
//  Created by Ali Ali on 12/2/2024.
//

import SwiftUI

struct TripView: View {
    let viewModel: TripViewModel
    
    init(trip: Trip){
        self.viewModel = TripViewModel(trip: trip)
    }
    
    var body: some View {
        VStack{
            if let journeys = viewModel.tripResponse?.journeys {
                withAnimation(Animation.easeIn(duration: 2).delay(0.5)) {
                    List(journeys, id:\.self){ journey in
                        VStack{
                            HStack{
                                Text("Departure time: ")
                                Text(journey.firstDepartureTimeEstimated, style: .time)
                            }
                            HStack{
                                Text("Arrival time: ")
                                Text(journey.firstArrivalTimeEstimatedDate, style: .time)
                            }
                            Text(journey.legsDescription)
                        }
                    }
                }
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

