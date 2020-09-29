//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct EmptyListView: View {
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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 480, maximum: 600))], spacing: 16) {
                ForEach(countdowns, id: \.id) { countdown in
                    CardFrontView(countdown: countdown)
                        .frame(height: 320)
                }
            }
            .padding()
        }
        .redacted(reason: .placeholder)
    }
}
