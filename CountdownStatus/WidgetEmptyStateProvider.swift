//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetEmptyStateProvider: View {
    let family: WidgetFamily

    var body: some View {
        switch family {
        case .systemLarge:
            return AnyView(WidgetEmptyStateLarge())
        case .systemMedium:
            return AnyView(WidgetEmptyStateMedium())
        case .systemSmall:
            return AnyView(WidgetEmptyStateSmall())
        @unknown default:
            return AnyView(WidgetEmptyStateLarge())
        }
    }
}
