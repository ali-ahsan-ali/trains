//
//  DottedLine.swift
//  Trains
//
//  Created by Ali Ali on 27/2/2024.
//

import SwiftUI

struct DottedLine: Shape {
        
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

#Preview {
    DottedLine()
}
