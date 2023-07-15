//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct AddStopView: View {

    enum AppState {
        case loading
        case success
        case error
    }
    
    @State private var state = AppState.loading
    @State var stops: Stops = Stops()

    func fetchData() {
        Task {
            do {
                let stops = try await GTFSManager().parseStops()
            } catch {
                // Handle error
            }
        }
    }


    var body: some View {
        VStack {
            content()
        }.onAppear {
            fetchData()
        }
        
    }
    
    @ViewBuilder
    func content() -> some View {
        if !self.stops.stops.isEmpty{
            successView()
        }else {
            Text("Loading")
        }
    }
    
    @ViewBuilder
    func successView() -> some View {
        List {
            ForEach(self.stops.stops , id: \.self) { stop in
                Row(stop: stop){
                    stop.selected.toggle()
                }
            }
        }.navigationTitle("Select a station to add")
        .listStyle(.insetGrouped)
    }
}

struct AddStopView_Previews: PreviewProvider {
    static var previews: some View {
        AddStopView()
    }
}
