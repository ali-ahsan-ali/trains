//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().largeTitleTextAttributes = [.font:UIFont.preferredFont(forTextStyle:.title1)]
    }
    
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
//                self.stops = try await GTFSManager().parseStops()
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
            }
            .navigationBarTitle("Trains", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddStopView(stops: <#T##Stops#>)) {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                    }
                }
            }
        }.onAppear {
            fetchData()
        }
        
    }
    
    @ViewBuilder
    func content() -> some View {
        if state == .loading{
            Text("Loading")
        }else if let stops{
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
