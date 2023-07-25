//
//  SearchCompleterView.swift
//  Trains
//
//  Created by Ali Ali on 24/7/2023.
//

import SwiftUI
import MapKit

struct SearchCompleter: View {
    @State var coordinate: CLLocationCoordinate2D?
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search..", text: $locationManager.search)
                    .textFieldStyle(.roundedBorder)
                List(locationManager.searchResults, id: \.self) {result in
                    VStack(alignment: .leading, spacing: 0) {
                        SearchCompleterLabelView(searchResult: result, locationManager: locationManager)
                    }
                    .onTapGesture {
                        getLocation(result)
                    }
                }
            }.padding()
            .navigationTitle(Text("Add Destination"))
        }
    }
    
    func getLocation(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil {
                self.coordinate = response?.mapItems[0].placemark.coordinate
            }else {
                print(error as Any)
            }
        }
    }
}

struct SearchCompleter_Previews: PreviewProvider {
    static var previews: some View {
        SearchCompleter(locationManager: LocationManager())
    }
}
