//
//  Row.swift
//  Trains
//
//  Created by Ali Ali on 16/7/2023.
//

import SwiftUI

struct Row: View {
    @StateObject var stop: Stop
    let onTap: (() -> Void)?

    var body: some View {
        HStack {
            Text(stop.name ?? "No Station Name").font(.headline).foregroundColor(.secondary)
            Image(systemName: stop.selected ? "checkmark.square.fill" :  "squareshape" )
                .foregroundColor(stop.selected ? .green : .gray)
        }.onTapGesture {
            onTap?()
        }
    }
}
