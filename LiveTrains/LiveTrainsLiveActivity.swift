//
//  LiveTrainsLiveActivity.swift
//  LiveTrains
//
//  Created by Ali Ali on 14/2/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveTrainsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LiveTrainsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveTrainsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveTrainsAttributes {
    fileprivate static var preview: LiveTrainsAttributes {
        LiveTrainsAttributes(name: "World")
    }
}

extension LiveTrainsAttributes.ContentState {
    fileprivate static var smiley: LiveTrainsAttributes.ContentState {
        LiveTrainsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LiveTrainsAttributes.ContentState {
         LiveTrainsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LiveTrainsAttributes.preview) {
   LiveTrainsLiveActivity()
} contentStates: {
    LiveTrainsAttributes.ContentState.smiley
    LiveTrainsAttributes.ContentState.starEyes
}
