//  Created by Gagandeep Singh on 20/9/20.

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    private let manager = CountdownsManager(context: PersistenceController.shared.container.viewContext)

    private var firstCountdown: Countdown? {
        manager.getAllObjects().first.map(Countdown.init)
    }

    private var placeholder: Countdown {
        firstCountdown ?? .placeholder
    }

    private func getCountdown(for configuration: SelectCountdownIntent) -> Countdown? {
        guard
            let id = configuration.countdown?.identifier,
            let uuid = UUID(uuidString: id) else { return nil }
        return manager.getObject(by: uuid).map(Countdown.init)
    }

    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), countdown: .placeholder, configuration: SelectCountdownIntent())
    }

    func getSnapshot(for configuration: SelectCountdownIntent, in context: Context, completion: @escaping (CountdownEntry) -> ()) {
        if context.isPreview {
            let entry = CountdownEntry(date: Date(), countdown: placeholder, configuration: configuration)
            return completion(entry)
        }

        guard let countdown = getCountdown(for: configuration) else {
            let entry = CountdownEntry(date: Date(), countdown: nil, configuration: configuration)
            return completion(entry)
        }

        let entry = CountdownEntry(date: Date(), countdown: countdown, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: SelectCountdownIntent, in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> ()) {
        let countdown = getCountdown(for: configuration) ?? firstCountdown

        var entries: [CountdownEntry] = []

        if countdown != nil {
            var date = Date()
            for _ in 0..<10 {
                entries.append(CountdownEntry(date: date, countdown: countdown, configuration: configuration))
                date = Calendar.current.date(byAdding: .second, value: 30, to: date)!
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
