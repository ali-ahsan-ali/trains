//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedStop: Stop = Stop()
    @State private var feed: Feed?
    
    func fetchData() {
        Task {
            if let retrievedStops = await GTFSManager().retrieve(url: "https://api.transport.nsw.gov.au/v1/gtfs/schedule/sydneytrains") {
                self.feed = retrievedStops
            } else {
                // Handle case where stops couldn't be retrieved
                self.feed = nil
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("HELP")
            }
        }.onAppear {
            fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
