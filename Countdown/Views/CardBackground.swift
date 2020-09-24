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


struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardBackground(imageURL: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0")
        }
    }
}
