//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct CountdonWidget : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let countdown = entry.countdown {
                WidgetCountdownProvider(
                    family: family,
                    title: countdown.title,
                    hasEnded: countdown.hasEnded,
                    date: countdown.date,
                    entryDate: entry.date,
                    image: countdown.image)
            } else {
                WidgetEmptyStateProvider(family: family)
            }
        }
    }
}

#if DEBUG
struct CountdownStatus_Previews: PreviewProvider {
    static var previews: some View {
        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: .placeholder, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: .placeholder, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: .placeholder, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))

        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: nil, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: nil, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        CountdonWidget(entry: CountdownEntry(date: Date(), countdown: nil, configuration: SelectCountdownIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
