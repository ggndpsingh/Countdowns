//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown
    let style: Style
    let flipHandler: () -> Void
    let closeHandler: () -> Void


    init(
        countdown: Countdown,
        style: CardFrontView.Style,
        flipHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}) {
        self.countdown = countdown
        self.style = style
        self.flipHandler = flipHandler
        self.closeHandler = closeHandler
    }


    enum Style {
        case thumbnail
        case details
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(image: countdown.image)
            switch style {
            case .thumbnail:
                title
            case .details:
                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        title
                        RoundButton(action: closeHandler, image: "xmark", color: .secondaryLabel)
                            .padding()
                    }
                    RoundButton(action: flipHandler, image: "square.and.pencil", color: .secondaryLabel)
                        .padding()
                }
            }
            CountdownView(date: countdown.date, size: style == .thumbnail ? .medium : .full)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .cornerRadius(16)
    }

    private var title: some View {
        TitleView(title: countdown.title, date: countdown.dateString, showDate: style == .details)
    }
}

#if DEBUG
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .preview, style: .details, flipHandler: {})
        }
    }
}
#endif
