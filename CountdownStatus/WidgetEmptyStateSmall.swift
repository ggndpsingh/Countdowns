//  Created by Gagandeep Singh on 21/9/20.

import WidgetKit
import SwiftUI

struct WidgetEmptyStateSmall: View {
    var body: some View {
        ZStack {
            Image(systemName: "info.circle.fill")
                .font(Font.dank(size: 12))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .foregroundColor(Color.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Select a countdown")
                    .font(Font.dank(size: 16))

                Text("Long press & select `Edit Widget`")
                    .font(Font.dank(size: 11))
            }
            .offset(y: 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.systemBackground)
    }
}

#if DEBUG
struct WidgetEmptyStateSmall_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEmptyStateSmall()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
