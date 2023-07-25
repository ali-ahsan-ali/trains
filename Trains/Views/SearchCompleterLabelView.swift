//
//  SearchCompleterLabelView.swift
//  Trains
//
//  Created by Ali Ali on 24/7/2023.
//

import SwiftUI
import MapKit

struct SearchCompleterLabelView: View {
    let searchResult: MKLocalSearchCompletion
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "pin")
                VStack(alignment: .leading, spacing: 10) {
                    Text(searchResult.title)
                    Text(searchResult.subtitle)
                }
            }
        }
    }
}
