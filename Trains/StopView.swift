//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct StopView: View {
    enum AppState {
        case loading
        case success
        case error
    }
    
    @State private var state = AppState.loading
    @State public var fromStop: Stop
    @State public var toStop: Stop

    func fetchData() {
        Task {
            do  {
                try await GTFSManager().parseFromStopTimes(stop: fromStop)
                try await GTFSManager().parseToStopTimes(stop: toStop)
                state = .success
            } catch {
                state = .error
                print(error)
            }
        }
    }

    public var body: some View {
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
        } else if self.fromStop.childStops.first?.stopTimes != nil && self.toStop.childStops.first?.stopTimes != nil {
            Text("DONE")
            ForEach(self.fromStop.childStops, id: \.self) { childStop in
                List(childStop.stopTimes.filter {$0.pickupType == 0 || $0.pickupType == nil }) { stopTime in
                    Text(stopTime.getArrivalTime())
                }
            }
        }else {
            Text("ERROR")
        }
    }
}
struct StopView_Previews: PreviewProvider {
    static var previews: some View {
        StopView(fromStop: Stop(), toStop: Stop())
    }
}
