//
//  LiveTrainsLiveActivity.swift
//  LiveTrains
//
//  Created by Ali Ali on 14/2/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveTrainsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveTrainsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 0) {
                HStack {
                    Text(context.attributes.startStopName)
                    Text("->")
                    Text(context.attributes.endStopName)
                }
                ForEach(context.state.times.prefix(4), id: \.self) { time in
                    ProgressView(timerInterval: Date.now...time.startTime)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 2)
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.startStopName)
                        .padding(.leading, 6)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.endStopName)
                        .padding(.trailing, 6)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ForEach(context.state.times.prefix(3), id: \.self) { time in
                        ProgressView(timerInterval: Date.now...time.startTime)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 2)
                    }
                    // more content
                }
            } compactLeading: {
                HStack {
                    Image(systemName: "train.side.front.car")
                        .resizable()
                        .frame(width: 30)
                    Text(context.attributes.startStopName.prefix(1))
                    Text("->")
                    Text(context.attributes.endStopName.prefix(1))
                }
            } compactTrailing: {
                HStack {
                    ForEach(context.state.times.prefix(2), id: \.self) { time in
                        let closedDateRange = (Date.now...time.startTime)
                        if closedDateRange.isEmpty {
                            Text("Now")
                        } else {
                            Text(timerInterval: Date.now...time.startTime, showsHours: false)
                                .minimumScaleFactor(0.1)
                        }
                    }
                }
            } minimal: {
                if let startTime = context.state.times.first?.startTime {
                    let closedDateRange = (Date.now...startTime)
                    if closedDateRange.isEmpty {
                        Text("Now")
                    } else {
                        Text(timerInterval: closedDateRange)
                    }
                }
            }
        }
    }
}

extension LiveTrainsAttributes {
    fileprivate static var preview: LiveTrainsAttributes {
        LiveTrainsAttributes(
            startStop: Stop(stopId: "1", stopName: "Pymble"),
            endStop: Stop(stopId: "1", stopName: "Redfern")
        )
    }
}

extension LiveTrainsAttributes.ContentState {
    fileprivate static var tripTimes: LiveTrainsAttributes.ContentState {
        LiveTrainsAttributes.ContentState(times: [
            TripTime(startTime: Date.now.addingTimeInterval(100), endTime: Date.now.addingTimeInterval(200)),
            TripTime(startTime: Date.now.addingTimeInterval(300), endTime: Date.now.addingTimeInterval(400)),
            TripTime(startTime: Date.now.addingTimeInterval(500), endTime: Date.now.addingTimeInterval(600)),
            TripTime(startTime: Date.now.addingTimeInterval(500), endTime: Date.now.addingTimeInterval(600)),
            TripTime(startTime: Date.now.addingTimeInterval(500), endTime: Date.now.addingTimeInterval(600))
            ]
        )
     }
}

#Preview("Notification", as: .content, using: LiveTrainsAttributes.preview) {
   LiveTrainsLiveActivity()
} contentStates: {
    LiveTrainsAttributes.ContentState.tripTimes
}
