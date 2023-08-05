//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import OpenTripPlannerApi

struct TripTimeView: View {
    let network = Network.shared
    let trip: TripViewModel

    var body: some View {
        VStack {
            Text(trip.fromStation.name)
            Text(trip.toStation.name)
        }
    }
}

struct TripTimeView_Previews: PreviewProvider {
    static var previews: some View {
        TripTimeView(trip: TripViewModel(fromStation: Station(name: "Pymble"), toStation: Station(name: "Redfern")))
    }
}
