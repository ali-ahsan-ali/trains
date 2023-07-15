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
    @State public var stop: Stop
    @State private var stopTimes: [String:[Date]]?

    func fetchData() {
        state = .loading
        Task {
            do  {
                stopTimes = try await GTFSManager().parseStopTimes(stop: stop)
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
        } else if self.stop.childStops.first?.stopTimes != nil {
            Text(self.stop.name ?? "No Station Name")
            ForEach(self.stop.childStops, id: \.self) { childStop in
                childStopView(childStop: childStop)
            }
        }else {
            Text("ERROR")
        }
    }
    
    @ViewBuilder
    func childStopView (childStop: Stop) -> some View {
        Text(platformName(parentName:self.stop.name, childName:childStop.name))
        ForEach(stopTimes?[childStop.stopID]?.prefix(10) ?? [], id: \.self) { time in
            Text(time.description(with: .current))
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
        StopView(stop: Stop())
    }
}
