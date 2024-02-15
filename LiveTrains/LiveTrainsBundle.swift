//
//  LiveTrainsBundle.swift
//  LiveTrains
//
//  Created by Ali Ali on 14/2/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct LiveTrainsBundle: WidgetBundle {
    var body: some Widget {
        LiveTrains()
        LiveTrainsLiveActivity()
    }
}
