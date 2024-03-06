//
//  TrainProgressLegend.swift
//  Trains
//
//  Created by Ali Ali on 27/2/2024.
//

import SwiftUI

struct TrainProgressLegend: View {
    @State private var legendSize: CGSize = .zero
    
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.green)
                Text("10+")
                    .font(.caption)
            }
            HStack {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color(hex: "#67B7D1"))
                Text("10>")
                    .font(.caption)
            }
            HStack {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.orange)
                Text("1>")
                    .font(.caption)
            }
            HStack {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.red)
                Text("Now")
                    .font(.caption)
            }
        }
    }
}

#Preview {
    TrainProgressLegend()
}
