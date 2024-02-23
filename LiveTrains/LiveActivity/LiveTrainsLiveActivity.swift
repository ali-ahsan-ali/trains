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
            VStack {
                Text("Hello")
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
                    ForEach(context.state.times.prefix(3), id: \.self){ time in
                        Text(time.startTime, style:.time)
                        Text(time.endTime, style:.time)
                    }
                    // more content
                }
            } compactLeading: {
                HStack{
                    Image(systemName: "train.side.front.car")
                        .resizable()
                        .frame(width: 30)
                    Text(context.attributes.startStopName.prefix(1))
                    Text("->")
                    Text(context.attributes.endStopName.prefix(1))
                }
            } compactTrailing: {
                HStack{
                    ForEach(context.state.times.prefix(2), id: \.self){ time in
                        let closedDateRange = (Date.now...time.startTime)
                        if closedDateRange.isEmpty {
                            Text("Now")
                        } else {
                            Text(timerInterval: Date.now...time.startTime)
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
        LiveTrainsAttributes(startStopName: "Pymble", endStopName: "Redfern")
    }
}

extension LiveTrainsAttributes.ContentState {
    fileprivate static var tripTimes: LiveTrainsAttributes.ContentState {
        LiveTrainsAttributes.ContentState(times: [
            TripTime(startTime: Date.now.addingTimeInterval(100), endTime: Date.now.addingTimeInterval(200)),
            TripTime(startTime: Date.now.addingTimeInterval(300), endTime: Date.now.addingTimeInterval(400)),
            TripTime(startTime: Date.now.addingTimeInterval(500), endTime: Date.now.addingTimeInterval(600)),
            ]
        )
     }
}

#Preview("Notification", as: .content, using: LiveTrainsAttributes.preview) {
   LiveTrainsLiveActivity()
} contentStates: {
    LiveTrainsAttributes.ContentState.tripTimes
}
