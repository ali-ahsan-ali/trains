//
//  LiveTrainProgressView.swift
//  Trains
//
//  Created by Ali Ali on 23/2/2024.
//

import SwiftUI

struct LiveTrainProgressView: View {
    let tripTime: TripTime
    
    var body: some View {
        VStack{
            ProgressView("")
            
            ProgressView(timerInterval: Date.now...tripTime.startTime, countsDown: false)
            
            ProgressView(value: 0.3, label: { Text("Processing...") }, currentValueLabel: { Text("30%") })
                .progressViewStyle(BarProgressStyle(height: 100.0))

        }
        .padding()
    }
}

struct BarProgressStyle: ProgressViewStyle {
    
    var color: Color = .purple
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
     
            let progress = configuration.fractionCompleted ?? 0.0
     
            GeometryReader { geometry in
     
                VStack(alignment: .leading) {
     
                    configuration.label
                        .font(labelFontStyle)
     
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(height: height)
                        .frame(width: geometry.size.width)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(color)
                                .frame(width: geometry.size.width * progress)
                                .overlay {
                                    if let currentValueLabel = configuration.currentValueLabel {
     
                                        currentValueLabel
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                        }
     
                }
     
            }
        }
}

#Preview {
    LiveTrainProgressView(tripTime: TripTime(startTime: Date.now.addingTimeInterval(100), endTime: Date.now.addingTimeInterval(200)))
}
