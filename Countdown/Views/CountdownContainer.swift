//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct CountdownContainer<C: View>: View {
    let hasEnded: Bool
    let countdown: () -> C
    private var isiPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    
    var body: some View {
        HStack(alignment: hasEnded ? .bottom : .top, spacing: 8) {
            countdown()

            if hasEnded {
                Text("ago")
                    .font(Font.system(size: isiPad ? 14 : 12, weight: .medium, design: .rounded))
                    .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
            }
        }
        .offset(x: hasEnded ? 8 : 0)
        .foregroundColor(.white)
    }
}
