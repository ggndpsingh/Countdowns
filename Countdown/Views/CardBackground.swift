//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let imageURL: String?

    var body: some View {
        ImageView(path: imageURL!)
            .cornerRadius(24)
            .contentShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .clipped(antialiased: false)
    }
}
