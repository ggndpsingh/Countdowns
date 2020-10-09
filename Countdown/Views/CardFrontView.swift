//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown
    let style: Style
    let addWatermark: Bool
    let flipHandler: () -> Void
    let closeHandler: () -> Void
    @State var sharing: Bool = false

    init(
        countdown: Countdown,
        style: CardFrontView.Style,
        addWatermark: Bool = false,
        flipHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}) {
        self.countdown = countdown
        self.style = style
        self.addWatermark = addWatermark
        self.flipHandler = flipHandler
        self.closeHandler = closeHandler
    }


    enum Style {
        case thumbnail
        case details
        case shareable

        var componentSize: CountdownSize {
            switch self {
            case .thumbnail, .shareable:
                return .medium
            case .details:
                return .full
            }
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(image: countdown.image, squareEdges: style == .shareable)
            switch style {
            case .thumbnail, .shareable:
                VStack(alignment: .leading) {
                    title
                    if addWatermark {
                        Spacer()
                        HStack {
                            Image("icon")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .cornerRadius(4)
                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
                            Text("Created with Countdowns")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0.5, y: 0.5)
                        }
                        .padding()
                    }
                }
                .padding([.top], 24)
            case .details:
                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        title

                        Spacer()

                        HStack(alignment: .top) {
                            RoundButton(
                                action: { sharing = true },
                                image: "square.and.arrow.up",
                                color: .secondary)
                                .sheet(isPresented: $sharing, content: {
                                    ShareView(countdown: countdown)
                                        .edgesIgnoringSafeArea(.all)
                                })

                            RoundButton(action: closeHandler, image: "xmark", color: .secondary)
                        }
                        .padding(.horizontal)
                        .frame(alignment: .top)
                    }

                    Spacer()

                    RoundButton(action: flipHandler, image: "square.and.pencil", color: .secondary)
                        .padding()
                }
                .padding([.top], 24)
            }
            CountdownView(date: countdown.date, size: style.componentSize, animate: style != .shareable)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var title: some View {
        TitleView(title: countdown.title, date: countdown.dateString, showDate: style == .details)
    }
}

#if DEBUG
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .preview, style: .thumbnail)
                .frame(width: 400, height: 400, alignment: .center)
                .previewLayout(.sizeThatFits)

            CardFrontView(countdown: .preview, style: .details)
                .frame(width: 400, height: 600, alignment: .center)
                .previewLayout(.sizeThatFits)
            CardFrontView(countdown: .preview, style: .thumbnail, addWatermark: true)
                .frame(width: 400, height: 400, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
