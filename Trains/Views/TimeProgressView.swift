//  TimeProgressView.swift
//  Trains
//
//  Created by Ali, Ali on 24/2/2024.
//

import SwiftUI
import Observation

struct TimeProgressView: View {
    let viewModel: ProgressBarViewModel
    
    var body: some View {
        ProgressView(value: viewModel.progress)
            .progressViewStyle(
                TrainProgressViewStyle(viewModel: viewModel)
            )
    }
}

struct TrainProgressViewStyle: ProgressViewStyle {
    let viewModel: ProgressBarViewModel
    @State private var oneMinuteSize: CGSize = .zero
    @State private var tenMinuteSize: CGSize = .zero

    func makeBody(configuration: Configuration) -> some View {
        if configuration.fractionCompleted != nil {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .fill(Color(uiColor: .systemGray5))
                            .overlay(alignment: .topLeading) {
                                animatingTrain(geometry: geometry)
                            }
                            .frame(height: 40)
                            .onChange(of: viewModel.progress) { _, _ in
                                let widthAvailableToTrains = max((getGeometryWidth(geometry: geometry) * viewModel.progress) - viewModel.imageViewSize.width, 0)
                                let numberOfTrainsThatCanFitInWidth = widthAvailableToTrains / (viewModel.imageViewSize.width + 4)
                                viewModel.numberOfTrains = Int(numberOfTrainsThatCanFitInWidth.rounded(.down))
                            }
                    }
                    
                    if viewModel.progressWhenWithin1Minutes != nil {
                        let oneMinBoundary = viewModel.oneMinuteTextOffset(widthOfView: getGeometryWidth(geometry: geometry), widthOfText: oneMinuteSize.width)
                        
                        // If there is overlap between the two views
                        if viewModel.tenMinuteTextOffset(widthOfView: getGeometryWidth(geometry: geometry), widthOfText: tenMinuteSize.width) + tenMinuteSize.width >= oneMinBoundary {
                            EmptyView()
                        } else {
                            Text("1 Min")
                                .font(.caption)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.onAppear { oneMinuteSize = geometry.size }
                                    }
                                )
                                .offset(
                                    x: viewModel.oneMinuteTextOffset(widthOfView: getGeometryWidth(geometry: geometry), widthOfText: tenMinuteSize.width)
                                )
                                .padding(.bottom, 55)
                                .multilineTextAlignment(.center)
                            
                            DottedLine()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                .frame(width: 1, height: 50)
                                .offset(
                                    x: viewModel.oneMinuteBarOffset(widthOfView: getGeometryWidth(geometry: geometry))
                                )
                        }
                    }
                    
                    if viewModel.progressWhenWithin10Minutes != nil {
                        Text("10 Min")
                            .font(.caption)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear.onAppear { tenMinuteSize = geometry.size }
                                }
                            )
                            .offset(
                                x: viewModel.tenMinuteTextOffset(widthOfView: getGeometryWidth(geometry: geometry), widthOfText: tenMinuteSize.width)
                            )
                            .padding(.bottom, 55)
                        DottedLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .frame(width: 1, height: 50)
                            .offset(
                                x: viewModel.tenMinuteBarOffset(widthOfView: getGeometryWidth(geometry: geometry))
                            )
                    }
                }
            }
            .frame(height: 55 + max(tenMinuteSize.height, oneMinuteSize.height), alignment: .center)
        } else {
            EmptyView()
        }
    }
    
    func getGeometryWidth(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width - 8
    }
    
    @ViewBuilder
    func animatingTrain(geometry: GeometryProxy) -> some View {
        let widthAvailableToTrains = max((getGeometryWidth(geometry: geometry) * viewModel.progress) - viewModel.imageViewSize.width, 0)
        
        HStack(spacing: 0) {
            ForEach(0...viewModel.numberOfTrains, id: \.self) { num in
                VStack {
                    if num == viewModel.numberOfTrains {
                        Image(systemName: "train.side.front.car")
                            .resizable()
                            .frame(width: viewModel.imageViewSize.width, height: viewModel.imageViewSize.height)
                            .foregroundStyle(viewModel.color)
                            .padding([.leading, .trailing], 2)
                    } else if num == 0 {
                        Image(systemName: "train.side.middle.car")
                            .resizable()
                            .frame(width: viewModel.imageViewSize.width, height: viewModel.imageViewSize.height)
                            .foregroundStyle(viewModel.color)
                            .padding([.leading, .trailing], 2)
                            .animation(.default, value: viewModel.numberOfTrains)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                    } else {
                        Image(systemName: "train.side.middle.car")
                            .resizable()
                            .frame(width: viewModel.imageViewSize.width, height: viewModel.imageViewSize.height)
                            .foregroundStyle(viewModel.color)
                            .padding([.leading, .trailing], 2)
                    }
                }
            }
        }
        .offset(
            x: widthAvailableToTrains - (CGFloat(viewModel.numberOfTrains) * (viewModel.imageViewSize.width + 4)),
            y: viewModel.imageViewSize.height / 2
        )
    }
}

#Preview {
    TimeProgressView(
        viewModel: ProgressBarViewModel(arrivalTime: Date.now.addingTimeInterval(20))
    )
}
