//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    private let countdown: Countdown
    private let isNew: Bool

    init(countdown: Countdown, isNew: Bool = false) {
        self.countdown = countdown
        self.isNew = isNew
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(image: countdown.image)
            TitleView(title: countdown.title, date: countdown.dateString, hasEnded: countdown.hasEnded)

            if !isNew {
                CountdownView(date: countdown.date, size: .medium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .cornerRadius(16)
    }
}

#if DEBUG
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .preview, isNew: true)

            CardFrontView(countdown: .preview, isNew: false)
                .frame(width: 300, height: 300, alignment: .center)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }.padding()
    }
}
#endif
