//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetCountdownSmall: View {
    let title: String
    let hasEnded: Bool
    let components: [DateComponent]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(Font.system(size: 20, weight: .medium, design: .default))
                .shadow(color: Color.black.opacity(0.4), radius: 1.5, x: 0.5, y: 0.5)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .foregroundColor(.white)
        .padding()

        CountdownContainer(hasEnded: hasEnded) {
            HStack(spacing: 4) {
                ForEach(components, id: \.self) {
                    ComponentView(component: $0).foregroundColor(.white)
                }
            }
        }
        .offset(y: 8)
    }
}
