//
//  ContentView.swift
//  Trains
//
//  Created by Ali, Ali on 8/6/2023.
//

import SwiftUI
import MapKit

struct FavouriteDestinationsView: View {
        var body: some View {
            VStack{
                SearchCompleter(locationManager: LocationManager())
                Spacer()
                List {
                    Text("Favorite")
                }
            }
        }
}
struct FavouriteDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteDestinationsView()
    }
}
