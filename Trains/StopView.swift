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
    @State private var cal: [String:CalendarRow]?
    @State private var trips: [String:Trip]?

    func fetchData() {
        state = .loading
        Task {
            do  {
                try await GTFSManager().parseFromStopTimes(stop: fromStop)
                self.cal = try await GTFSManager().parseCal()
                self.trips = try await GTFSManager().parseTrips()
                if self.cal != nil && self.trips != nil {
                    state = .success
                }else {
                    state = .error
                }
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
        } else if self.fromStop.childStops.first?.stopTimes != nil {
            Text(self.fromStop.name ?? "No Station Name")
            ForEach(self.fromStop.childStops, id: \.self) { childStop in
                Text(platformName(parentName:self.fromStop.name, childName:childStop.name))
                List(childStop.stopTimes.filter {$0.pickupType == 0 || $0.pickupType == nil }) { stopTime in
                    Text(stopTime.getArrivalTime())
                }
            }
        }else {
            Text("ERROR")
        }
    }
    
    func platformName(parentName: String?, childName: String?) -> String {
        if parentName == nil { return childName ?? "No Platform Name" }
        if childName == nil { return parentName ?? "No Platform Name" }
        if let component1 = parentName?.split(separator: " "), let component2 = childName?.split(separator: " ") {
            let result: [String] = component2.enumerated().compactMap { index, string in
                if index < component1.count && component1[index] == component2[index] {
                    return nil
                }
                return String(string)
            }
            return result.joined(separator: " ")
        }
        return "No Platform Name"
    }
}
struct StopView_Previews: PreviewProvider {
    static var previews: some View {
        StopView(fromStop: Stop())
    }
}
