//  TimeProgressView.swift
//  Trains
//
//  Created by Ali, Ali on 24/2/2024.
//

import SwiftUI
import Observation
import Combine

@Observable
class ProgressBarViewModel {
    init(
        tripTime: ClosedRange<Date>
    ) {
        lowerTime = tripTime.lowerBound.timeIntervalSinceReferenceDate
        totalTime = (tripTime.lowerBound.timeIntervalSinceReferenceDate - Date.now.timeIntervalSinceReferenceDate).rounded()
        originalTime = Date.now.timeIntervalSinceReferenceDate
        currentTime = Date.now.timeIntervalSinceReferenceDate
        Timer.publish(
            every: 0.001,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] date in
            guard let self else {
                return
            }
            guard self.currentTime < self.lowerTime else {
                return
            }
            self.currentTime = date.timeIntervalSinceReferenceDate
        }
        .store(in: &cancellable )
    }
    
    let lowerTime: TimeInterval
    let originalTime: TimeInterval
    let totalTime: TimeInterval
    var currentTime: TimeInterval
    
    @ObservationIgnored var cancellable = Set<AnyCancellable>()
    
    var progress: Double {
        return (currentTime - originalTime) / totalTime
    }
    
    var isPastStartTime: Bool {
        currentTime > lowerTime
    }
    
    var within1Minute: Bool {
        lowerTime - currentTime <= 60
    }
    
}



struct TimeProgressView: View {
    let viewModel: ProgressBarViewModel
    
    var body: some View {
        ProgressView(value: viewModel.progress)
            .progressViewStyle(
                TrainProgressViewStyle(isPastStartTime: viewModel.isPastStartTime, within1Minute: viewModel.within1Minute)
            )
    }
}

struct TrainProgressViewStyle: ProgressViewStyle {
    let isPastStartTime: Bool
    let within1Minute: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color(uiColor: .systemGray5))
                .frame(height: 40, alignment:.center)
                .overlay {
                    GeometryReader { geometry in
                        animatingTrain(geometry: geometry, progress: configuration.fractionCompleted)
                            .frame(alignment: .center)
                    }
                    .border(.red)
                }
        }
    }
    
    var color: Color {
        if isPastStartTime{
            .red
        } else if within1Minute {
            .orange
        } else {
            .green
        }
    }
    
    @ViewBuilder
    func animatingTrain(geometry: GeometryProxy, progress: Double?) -> some View {
        if let progress {
            let imageViewSize: CGSize = .init(width: 20, height: 20)
            let widthAvailableToTrains = (geometry.size.width - imageViewSize.width) * progress
            if widthAvailableToTrains.isZero{
                EmptyView()
            } else {
                let numberOfTrainsThatCanFitInWidth = widthAvailableToTrains / (imageViewSize.width+4)
                let numberOfTrains = Int(numberOfTrainsThatCanFitInWidth.rounded(.down))
                
                VStack{
                    HStack(spacing: 0){
                        ForEach(0...numberOfTrains, id: \.self){ num in
                            VStack{
                                if num == numberOfTrains {
                                    Image(systemName: "train.side.front.car")
                                        .resizable()
                                        .frame(width: imageViewSize.width, height: imageViewSize.height)
                                        .foregroundStyle(color)
                                        .padding([.leading, .trailing], 2)
                                } else {
                                    Image(systemName: "train.side.middle.car")
                                        .resizable()
                                        .frame(width: imageViewSize.width, height: imageViewSize.height)
                                        .foregroundStyle(color)
                                        .padding([.leading, .trailing], 2)
                                }
                            }
                        }
                    }
                    .offset(
                        x: widthAvailableToTrains - (CGFloat(numberOfTrains) * (imageViewSize.width + 4)),
                        y: imageViewSize.height/2
                    )
                    .animation(.spring, value: numberOfTrains)
                }
            }
        } else {
            EmptyView()
        }
    }
}


#Preview {
    TimeProgressView(
        viewModel: ProgressBarViewModel( tripTime: Date.now.addingTimeInterval(10)...Date.now.addingTimeInterval(20))
    )
}
