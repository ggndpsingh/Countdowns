//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetEmptyStateLarge: View {
    var body: some View {
        ZStack {
            Image(systemName: "info.circle.fill")
                .font(Font.system(size: 12, weight: .regular, design: .default))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(Color.secondaryLabel)

            VStack(alignment: .center, spacing: 4) {
                Text("Select a countdown")
                    .font(Font.system(size: 24, weight: .regular, design: .default))

                Text("Long press & select Edit Widget")
                    .font(Font.system(size: 12, weight: .regular, design: .default))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.systemBackground)
    }
}

struct WidgetEmptyStateLarge_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEmptyStateLarge()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
