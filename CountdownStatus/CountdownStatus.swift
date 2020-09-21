//  Created by Gagandeep Singh on 20/9/20.

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    let storage = CountdownStorage()

    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), countdown: .placeholder, configuration: SelectCountdownIntent())
    }

    func getSnapshot(for configuration: SelectCountdownIntent, in context: Context, completion: @escaping (CountdownEntry) -> ()) {
        if context.isPreview {
            let countdown = storage.getCountdowns().randomElement() ?? .placeholder
            let entry = CountdownEntry(date: Date(), countdown: countdown, configuration: configuration)
            return completion(entry)
        }

        guard let id = configuration.countdown?.identifier, let countdown = storage.getCountdown(id: id) else {
            let entry = CountdownEntry(date: Date(), countdown: nil, configuration: configuration)
            return completion(entry)
        }

        let entry = CountdownEntry(date: Date(), countdown: countdown, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SelectCountdownIntent, in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> ()) {
        var countdown = storage.getCountdowns().randomElement()

        if let id = configuration.countdown?.identifier, let stored = storage.getCountdown(id: id) {
            countdown = stored
        }

        var entries: [CountdownEntry] = []

        if countdown != nil {
            var date = Date()
            for _ in 0..<15 {
                entries.append(CountdownEntry(date: date, countdown: countdown, configuration: configuration))
                date = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
            }
        } else {
            entries.append(.init(date: Date(), countdown: nil, configuration: configuration))
        }

        let timeline = Timeline(
            entries:entries,
            policy: .atEnd
        )

        completion(timeline)
    }
}

struct CountdownEntry: TimelineEntry {
    let date: Date
    let countdown: Countdown?
    let configuration: SelectCountdownIntent
}

@main
struct CountdownStatus: Widget {
    let kind: String = "CountdownStatus"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectCountdownIntent.self, provider: Provider()) { entry in
            CountdonWidget(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
