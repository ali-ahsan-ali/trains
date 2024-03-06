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
        .sink { [weak self] _ in
            guard let self, self.currentTime < self.lowerTime else {
                return
            }
            self.currentTime += 0.001
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

    let imageViewSize: CGSize = .init(width: 8, height: 8)

    @ObservationIgnored var cancellable = Set<AnyCancellable>()
    
    var progress: Double {
        return (currentTime - originalTime) / totalTime
    }
    
    var isPastStartTime: Bool {
        currentTime > lowerTime
    }
    
    var within10Minute: Bool {
        lowerTime - currentTime <= 600
    }
    
    var within1Minute: Bool {
        lowerTime - currentTime <= 60
    }

    var progressWhenWithin1Minutes: Double {
        return (totalTime - 60) / totalTime
    }
    
    var progressWhenWithin10Minutes: Double {
        return (totalTime - 600) / totalTime
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
        return max(min(CGFloat(progressWhenWithin1Minutes) * widthOfView + 2, widthOfView), 0)
    }
    
    func tenMinuteBarOffset(widthOfView: CGFloat) -> CGFloat {
        return max(min(CGFloat(progressWhenWithin10Minutes) * widthOfView + 2, widthOfView), 0)
    }
    
    func oneMinuteTextOffset(widthOfView: CGFloat, widthOfText: CGFloat) -> CGFloat {
        return max(min(CGFloat(progressWhenWithin1Minutes) * widthOfView - (widthOfText / 2), widthOfView - widthOfText), 0)
    }
    
    func tenMinuteTextOffset(widthOfView: CGFloat, widthOfText: CGFloat) -> CGFloat {
        return max(min(CGFloat(progressWhenWithin10Minutes) * widthOfView - (widthOfText / 2), widthOfView - widthOfText), 0)
    }
        
    func overlapCase(widthOfView: CGFloat, widthOfOneMinText: CGFloat, widthOfTenMinText: CGFloat) -> ShowText {
        if tenMinuteTextOffset(widthOfView: widthOfView, widthOfText: widthOfOneMinText) == 0 && oneMinuteTextOffset(widthOfView: widthOfView, widthOfText: widthOfTenMinText) == 0 {
            if progressWhenWithin1Minutes < 0 && progressWhenWithin10Minutes < 0 {
                return .none
            } else {
                return .one
            }
        } else if tenMinuteTextOffset(widthOfView: widthOfView, widthOfText: widthOfOneMinText) + widthOfOneMinText > oneMinuteTextOffset(widthOfView: widthOfView, widthOfText: widthOfTenMinText) {
            if progressWhenWithin1Minutes.rounded(.down) == 0 {
                return .ten
            } else {
                return .one
            }
        } else {
            if progressWhenWithin1Minutes < 0 && progressWhenWithin10Minutes < 0 {
                return .none
            } else if progressWhenWithin1Minutes < 0 {
                return .ten
            } else if progressWhenWithin10Minutes < 0 {
                return .one
            } else {
                return .both
            }
        }
    }
}

enum ShowText {
    case both
    case one
    case ten
    case none
}
