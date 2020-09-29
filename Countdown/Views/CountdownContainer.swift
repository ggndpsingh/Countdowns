//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct CountdownContainer<C: View>: View {
    let hasEnded: Bool
    let countdown: () -> C

    var body: some View {
        HStack(alignment: hasEnded ? .bottom : .top, spacing: 8) {
            countdown()

            if hasEnded {
                Text("ago")
                    .font(Font.dank(size: 12))
                    .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
                    .offset(x: -8)
            }
        }
        .offset(x: hasEnded ? 8 : 0)
        .foregroundColor(.white)
    }
}
