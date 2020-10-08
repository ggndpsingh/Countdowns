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
    let imageHandler: () -> Void
    let doneHandler:  (Countdown) -> Void
    let closeHandler:  () -> Void
    let deleteHandler: () -> Void

    private var calculatedVisibleSide: FlipViewSide {
        isNewPublisher.isNew ? .back : visibleSide
    }

    internal init(
        countdown: Countdown,
        isNew: Bool,
        imageHandler: @escaping () -> Void,
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
                viewModel: .init(
                    countdown: countdown,
                    isNew: isNewPublisher.isNew,
                    countdownsManager: countdownsManager),
                isEditing: calculatedVisibleSide == .back,
                imageHandler: imageHandler,
                doneHandler: {
                    if isNewPublisher.isNew {
                        isNewPublisher.isNew = false
                    } else {
                        flipCard()
                    }

                    doneHandler($0)
                },
                deleteHandler: deleteHandler)
                .cornerRadius(16)
        }
        .animation(.flipCard, value: visibleSide)
    }

    func flipCard() {
        visibleSide.toggle()
    }
}

#if DEBUG
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(countdown: .preview, isNew: false, imageHandler: {}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)

            CardView(countdown: .preview, isNew: false, imageHandler: {}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
