//
//  TimeProgressBarViewModel.swift
//  Trains
//
//  Created by Ali Ali on 27/2/2024.
//

import Foundation
import Combine
import SwiftUI

@Observable
class ProgressBarViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(lowerTime)
    }
    
    static func == (lhs: ProgressBarViewModel, rhs: ProgressBarViewModel) -> Bool {
        lhs.lowerTime == rhs.lowerTime
    }
    
    init(
        arrivalTime: Date
    ) {
        self.tripTime = Date.now...arrivalTime
        lowerTime = arrivalTime.timeIntervalSinceReferenceDate
        totalTime = (arrivalTime.timeIntervalSinceReferenceDate - Date.now.timeIntervalSinceReferenceDate).rounded()
        originalTime = Date.now.timeIntervalSinceReferenceDate
        currentTime = Date.now.timeIntervalSinceReferenceDate
        Timer.publish(
            every: 0.001,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] date in
            guard let self, self.currentTime < self.lowerTime else {
                return
            }
            self.currentTime = date.timeIntervalSinceReferenceDate
        }
        .store(in: &cancellable )
    }
    
    let tripTime: ClosedRange<Date>

    private let lowerTime: TimeInterval
    private let originalTime: TimeInterval
    private let totalTime: TimeInterval
    private var currentTime: TimeInterval
    var numberOfTrains: Int = 0
    
    var start: CGPoint = .zero
    var end: CGPoint = .zero

    let imageViewSize: CGSize = .init(width: 20, height: 20)

    @ObservationIgnored var cancellable = Set<AnyCancellable>()
    
    var progress: Double {
        return (currentTime - originalTime) / totalTime
    }
    
    var isPastStartTime: Bool {
        currentTime > lowerTime
    }
    
    var within10Minute: Bool {
        lowerTime - currentTime <= 15
    }
    
    var within1Minute: Bool {
        lowerTime - currentTime <= 5
    }

    var progressWhenWithin1Minutes: Double? {
        let roundedValue = Double(round(100 * ((totalTime - 5) / totalTime)) / 100)
        if roundedValue <= 0.01 { return nil }
        return (totalTime - 5) / totalTime
    }
    
    var progressWhenWithin10Minutes: Double? {
        let roundedValue = Double(round(100 * ((totalTime - 15) / totalTime)) / 100)
        if roundedValue <= 0.01 { return nil }
        return (totalTime - 15) / totalTime
    }
    
    var color: Color {
        if isPastStartTime {
            .red
        } else if within1Minute {
            .orange
        } else if within10Minute {
            Color(hex: "#67B7D1")
        } else {
            .green
        }
    }
    
    func oneMinuteBarOffset(widthOfView: CGFloat) -> CGFloat {
        guard let progressWhenWithin1Minutes else { return .infinity }
        return min(CGFloat(progressWhenWithin1Minutes) * widthOfView + 2, widthOfView)
    }
    
    func tenMinuteBarOffset(widthOfView: CGFloat) -> CGFloat {
        guard let progressWhenWithin10Minutes else { return .infinity }
        return min(CGFloat(progressWhenWithin10Minutes) * widthOfView + 2, widthOfView)
    }
    
    func oneMinuteTextOffset(widthOfView: CGFloat, widthOfText: CGFloat) -> CGFloat {
        guard let progressWhenWithin1Minutes else { return .infinity }
        return min(CGFloat(progressWhenWithin1Minutes) * widthOfView - (widthOfText / 2), widthOfView - widthOfText)
    }
    
    func tenMinuteTextOffset(widthOfView: CGFloat, widthOfText: CGFloat) -> CGFloat {
        guard let progressWhenWithin10Minutes else { return .infinity }
        return min(CGFloat(progressWhenWithin10Minutes) * widthOfView - (widthOfText / 2), widthOfView - widthOfText)
    }
}
