//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetEmptyStateMedium: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "info.circle.fill")
                .font(Font.system(size: 12, weight: .regular, design: .default))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(Color.secondaryLabel)

            VStack(alignment: .leading, spacing: 4) {
                Text("Select a countdown")
                    .font(Font.system(size: 16, weight: .regular, design: .default))

                Text("Long press & select `Edit Widget`")
                    .font(Font.system(size: 11, weight: .regular, design: .default))
            }
            .offset(y: 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.systemBackground)
    }
}

struct WidgetEmptyStateMedium_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEmptyStateMedium()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}