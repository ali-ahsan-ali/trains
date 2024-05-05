//
//  Shimmer.swift
//  Trains
//
//  Created by Ali Ali on 18/2/2024.
//

import SwiftUI

struct Shimmer: View {
    private let gradientColors: [Color] = [
        Color(uiColor: .systemGray5),
        Color(uiColor: .systemGray6),
        Color(uiColor: .systemGray5)
    ]
    
    @State var startPoint: UnitPoint = .init(x: -1, y: 0.5)
    @State var endPoint: UnitPoint = .init(x: 0, y: 0.5)
    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1.5, y: 0.5)
                    endPoint = .init(x: 2.5, y: 0.5)
                }
            }
    }
}

#Preview {
    Shimmer()
}
