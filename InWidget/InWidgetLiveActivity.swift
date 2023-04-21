//
//  InWidgetLiveActivity.swift
//  InWidget
//
//  Created by YouUp Lee on 2023/04/19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct InWidgetAttributes: ActivityAttributes {
  
  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    var value: Int
  }
  
  // Fixed non-changing properties about your activity go here!
  var name: String
}



struct InWidgetLiveActivity: Widget {
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: InWidgetAttributes.self) { context in
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
          Text("Leading")
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text("Trailing")
        }
        DynamicIslandExpandedRegion(.bottom) {
          Text("Bottom")
          // more content
        }
      } compactLeading: {
        Text("L")
      } compactTrailing: {
        Text("T")
      } minimal: {
        Text("Min")
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}



struct InWidgetLiveActivity_Previews: PreviewProvider {
  
  static let attributes = InWidgetAttributes(name: "Me")
  static let contentState = InWidgetAttributes.ContentState(value: 3)
  
  static var previews: some View {
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.compact))
      .previewDisplayName("Island Compact")
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
      .previewDisplayName("Island Expanded")
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
      .previewDisplayName("Minimal")
    attributes
      .previewContext(contentState, viewKind: .content)
      .previewDisplayName("Notification")
  }
}
