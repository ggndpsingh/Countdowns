//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(image: countdown.image)
            TitleView(title: countdown.title, date: countdown.dateString, hasEnded: countdown.hasEnded)
            CountdownView(date: countdown.date, size: .medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .cornerRadius(16)
    }
}

#if DEBUG
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .preview)

            CardFrontView(countdown: .preview)
                .frame(width: 300, height: 300, alignment: .center)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }.padding()
    }
}
#endif
