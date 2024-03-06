////
////  LiveTrainsLiveActivity.swift
////  LiveTrains
////
////  Created by Ali Ali on 14/2/2024.
////
//
//import ActivityKit
//import WidgetKit
//import SwiftUI
//import AppIntents
//
//struct LiveTrainsLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: LiveTrainsAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            VStack {
//                TripProgressView(tripAttributes: context.attributes, tripTimes: context.state)
//            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                // Expanded UI goes here.  Compose the expanded UI through
//                // various regions, like leading/trailing/center/bottom
//                DynamicIslandExpandedRegion(.leading) {
//                    Text(context.attributes.startStopName)
//                        .padding(.leading, 6)
//                        .font(.subheadline)
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text(context.attributes.endStopName)
//                        .padding(.trailing, 6)
//                        .font(.subheadline)
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    TripProgressView(tripAttributes: context.attributes, tripTimes: context.state)
//                }
//            } compactLeading: {
//                HStack(spacing: 4) {
//                    Button(intent: ReloadLiveTrainIntent()) {
//                        Image(systemName: "arrow.clockwise.circle.fill")
//                    }
//                    Text(context.attributes.startStopName.prefix(1))
//                    Text("->")
//                    Text(context.attributes.endStopName.prefix(1))
//                }
//            } compactTrailing: {
//                HStack {
//                    ForEach(context.state.times.prefix(2), id: \.self) { time in
//                        let closedDateRange = (Date.now...time.startTime)
//                        if closedDateRange.isEmpty {
//                            Text("Now")
//                        } else {
//                            Text(timerInterval: Date.now...time.startTime, showsHours: false)
//                                .minimumScaleFactor(0.1)
//                        }
//                    }
//                }
//            } minimal: {
//                if let startTime = context.state.times.first?.startTime {
//                    let closedDateRange = (Date.now...startTime)
//                    if closedDateRange.isEmpty {
//                        Text("Now")
//                    } else {
//                        Text(timerInterval: closedDateRange)
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension LiveTrainsAttributes {
//    fileprivate static var preview: LiveTrainsAttributes {
//        LiveTrainsAttributes(startStopName: "Pymble", endStopName: "Redfern")
//    }
//}
//
//extension LiveTrainsAttributes.ContentState {
//    fileprivate static var tripTimes: LiveTrainsAttributes.ContentState {
//        LiveTrainsAttributes.ContentState(times: [
//            TripTime(startTime: Date.now.addingTimeInterval(100), endTime: Date.now.addingTimeInterval(200)),
//            TripTime(startTime: Date.now.addingTimeInterval(300), endTime: Date.now.addingTimeInterval(400)),
//            TripTime(startTime: Date.now.addingTimeInterval(500), endTime: Date.now.addingTimeInterval(600))
//            ]
//        )
//     }
//}
//
//struct ReloadLiveTrainIntent: AppIntent {
//    static var title: LocalizedStringResource = "Reload Trains"
//    static var description = IntentDescription("Refresh Train info")
//
//   func perform() async throws -> some IntentResult {
//       try await FavouriteTripViewManager.shared.viewModel?.loadTrip()
//       await FavouriteTripViewManager.shared.viewModel?.updateTrips()
//       return .result()
//   }
//}
//
//struct EndLiveTrainIntent: AppIntent {
//    static var title: LocalizedStringResource = "Reload Trains"
//    static var description = IntentDescription("Refresh Train info")
//
//   func perform() async throws -> some IntentResult {
//       await FavouriteTripViewManager.shared.viewModel?.currentActivity?.end(.none, dismissalPolicy: .immediate)
//       return .result()
//   }
//}
//
//#Preview("Notification", as: .content, using: LiveTrainsAttributes.preview) {
//   LiveTrainsLiveActivity()
//} contentStates: {
//    LiveTrainsAttributes.ContentState.tripTimes
//}
