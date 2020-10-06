//  Created by Gagandeep Singh on 20/9/20.

import WidgetKit
import SwiftUI
import Intents

extension Countdown {
    static let placeholder: Countdown = {
        .init(id: .init(), date: .christmas, title: "Christmas 🎄", image: .randomSample)
    }()
}

struct Provider: IntentTimelineProvider {
    private let manager = CountdownsManagerKey.defaultValue

    private var firstCountdown: Countdown? {
        manager.getFirstPendingObject().map(Countdown.init)
    }

    private var placeholder: Countdown {
        firstCountdown ?? .placeholder
    }

    private var preview: Countdown {
        firstCountdown ?? .placeholder
    }

    private func getCountdown(for configuration: SelectCountdownIntent) -> Countdown? {
        guard
            let id = configuration.countdown?.identifier,
            let uuid = UUID(uuidString: id)
        else { return nil }
        return manager.getObject(by: uuid).map(Countdown.init) ?? manager.getFirstPendingObject().map(Countdown.init)
    }

    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), countdown: placeholder, configuration: SelectCountdownIntent())
    }

    func getSnapshot(for configuration: SelectCountdownIntent, in context: Context, completion: @escaping (CountdownEntry) -> ()) {
        if context.isPreview {
            let entry = CountdownEntry(date: Date(), countdown: preview, configuration: configuration)
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
        .configurationDisplayName("Countdown")
        .description("Add one of our countdowns to the home screen.")
    }
}
