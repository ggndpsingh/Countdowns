//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(image: countdown.image)
                .overlay(Rectangle().fill(Color.black.opacity(0.3)))
            TitleView(title: countdown.title, date: countdown.dateString)
            CountdownView(date: countdown.date, size: .medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: 8)
        }
        .cornerRadius(24)
    }
}

#if DEBUG
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .preview)

            CardFrontView(countdown: .preview)
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }.padding()
    }
}
#endif
