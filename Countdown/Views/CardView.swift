//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardView: View {
    @Environment(\.countdownsManager) private var countdownsManager
    @State private var flipped: Bool = false
    let countdown: Countdown
    let imageHandler: (PhotoSource) -> Void
    let doneHandler:  (Countdown) -> Void
    let closeHandler:  () -> Void
    let deleteHandler: () -> Void

    @State private var visibleSide = FlipViewSide.front

    internal init(
        countdown: Countdown,
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
    }

    var body: some View {
        FlipView(visibleSide: visibleSide) {
            CardFrontView(
                countdown: countdown,
                style: .details,
                flipHandler: flipCard,
                closeHandler: closeHandler)
        } back: {
            CardBackView(
                viewModel: .init(countdown: countdown, isNew: false, countdownsManager: countdownsManager), imageHandler: imageHandler,
                doneHandler: {
                    flipCard()
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
            CardView(countdown: .preview, visibleSide: .front, imageHandler: {_ in}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)

            CardView(countdown: .preview, visibleSide: .front, imageHandler: {_ in}, doneHandler: {_ in}, closeHandler: {}, deleteHandler: {})
                .frame(maxWidth: 520, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
