//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

final class CardIsNewPublisher: ObservableObject {
    var isNew: Bool

    init(isNew: Bool) {
        self.isNew = isNew
    }
}

struct CardView: View {
    @Environment(\.countdownsManager) private var countdownsManager
    @State private var visibleSide = FlipViewSide.front
    var isNewPublisher: CardIsNewPublisher

    let countdown: Countdown
    let imageHandler: (PhotoSource) -> Void
    let doneHandler:  (Countdown) -> Void
    let closeHandler:  () -> Void
    let deleteHandler: () -> Void

    private var calculatedVisibleSide: FlipViewSide {
        isNewPublisher.isNew ? .back : visibleSide
    }

    internal init(
        countdown: Countdown,
        isNew: Bool,
        visibleSide: FlipViewSide,
        imageHandler: @escaping (PhotoSource) -> Void,
        doneHandler: @escaping (Countdown) -> Void,
        closeHandler: @escaping () -> Void,
        deleteHandler: @escaping () -> Void) {

        self.countdown = countdown
        self.imageHandler = imageHandler
        self.doneHandler = doneHandler
        self.closeHandler = closeHandler
        self.deleteHandler = deleteHandler
        self.isNewPublisher = .init(isNew: isNew)
    }

    var body: some View {
        FlipView(visibleSide: calculatedVisibleSide) {
            CardFrontView(
                countdown: countdown,
                style: .details,
                flipHandler: flipCard,
                closeHandler: closeHandler)
        } back: {
            CardBackView(
                viewModel: .init(countdown: countdown, isNew: isNewPublisher.isNew, countdownsManager: countdownsManager), imageHandler: imageHandler,
                doneHandler: {
                    if isNewPublisher.isNew {
                        isNewPublisher.isNew = false
                    } else {
                        flipCard()
                    }

                    doneHandler($0)
                },
                deleteHandler: deleteHandler)
        }
//        .contentShape(Rectangle())
        .animation(.flipCard, value: visibleSide)
//        .onAppear {
//            if isNew {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
//                        flipped = true
//                    }
//                }
//            }
//        }
    }

    func flipCard() {
        visibleSide.toggle()
    }
}

#if DEBUG
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(countdown: .preview, isNew: false, visibleSide: .front, imageHandler: {_ in}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)

            CardView(countdown: .preview, isNew: false, visibleSide: .front, imageHandler: {_ in}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
