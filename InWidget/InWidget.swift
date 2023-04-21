//
//  InWidget.swift
//  InWidget
//
//  Created by YouUp Lee on 2023/04/19.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent())
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}



struct SimpleEntry: TimelineEntry {
  
  let date: Date
  let configuration: ConfigurationIntent
}



struct InWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}



struct InWidget: Widget {
  let kind: String = "InWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      InWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("칼퇴 계산기")
    .description("근무시간 관련 정보를 위젯으로 볼 수 있습니다")
  }
}



struct InWidget_Previews: PreviewProvider {
  
  static var previews: some View {
    InWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
