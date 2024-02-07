//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI

struct ContentView: View {
    init() { // swiftlint:disable:this type_contents_order
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
    }

    @StateObject var vm = TripViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("HI")
            }
            .navigationBarTitle("Trips")
            .onAppear {
                Task {
                    try? await vm.retreiveTripDetails()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
