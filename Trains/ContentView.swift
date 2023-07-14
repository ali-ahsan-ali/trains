//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct ContentView: View {
    enum AppState {
        case loading
        case success
        case error
    }
    
    @State private var state = AppState.loading
    @State private var fromStop: Stop = Stop()
    @State private var stops: Stops?

    func fetchData() {
        Task {
            do  {
                self.stops = try await GTFSManager().parseStops()
                //                await GTFSManager().setUpApp(stops: self.stops!)
                state = .success
                
            } catch {
                state = .error
                print(error)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                content()
            }
        }.onAppear {
            fetchData()
        }.navigationBarTitle("Home")
    }
    
    @ViewBuilder
    func content() -> some View {
        if state == .loading{
            Text("Loading")
        }else if let stops{
            Picker("From", selection: $fromStop) {
                ForEach(stops.stops, id: \.self) { stop in
                    Text(stop.name ?? "No Name for Station: \(stop.stopID)")
                        .tag(stop)
                }
            }
            NavigationLink(destination: StopView(fromStop: fromStop)) {
                Text("Go to Detail")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }else {
            Text("ERROR")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
