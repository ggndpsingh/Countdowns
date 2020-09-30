//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct EmptyListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var countdowns: [Countdown] {
        var countdowns: [Countdown] = []
        for _ in 0..<4 {
            countdowns.append(
                .init(
                    id: .init(),
                    date: Date().addingTimeInterval(3600 * 3600),
                    title: "This is a placeholder",
                    image: nil))
        }
        return countdowns
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 380, maximum: 520))], spacing: 16) {
                ForEach(countdowns, id: \.id) { countdown in
                    CardFrontView(countdown: countdown, style: .thumbnail, flipHandler: {})
                        .contentShape(Rectangle())
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding()
        }
        .redacted(reason: .placeholder)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
