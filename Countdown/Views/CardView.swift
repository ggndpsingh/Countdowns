//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardView: View {
    @Environment(\.countdownsManager) private var countdownsManager
    @State private var flipped: Bool = false
    let countdown: Countdown
    let isFlipped: Bool
    let isNew: Bool
    let tapHandler: (UUID) -> Void
    let imageHandler: () -> Void
    let doneHandler:  (Countdown, Bool) -> Void
    let deleteHandler: () -> Void

    internal init(
        countdown: Countdown,
        isFlipped: Bool,
        isNew: Bool,
        tapHandler: @escaping (UUID) -> Void,
        imageHandler: @escaping () -> Void,
        doneHandler: @escaping (Countdown, Bool) -> Void,
        deleteHandler: @escaping () -> Void) {

        self.countdown = countdown
        self.isFlipped = isFlipped
        self.isNew = isNew
        self.tapHandler = tapHandler
        self.imageHandler = imageHandler
        self.doneHandler = doneHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        FlipView(
            isFlipped: flipped || isFlipped,
            front:{
                CardFrontView(
                    countdown: countdown)
                    .onTapGesture { tapHandler(countdown.id) }
                    .frame(height: 320)
            }, back: {
                CardBackView(
                    viewModel: .init(countdown: countdown, isNew: isNew, countdownsManager: countdownsManager), imageHandler: imageHandler,
                    doneHandler: {
                        if flipped {
                            withFlipAnimation(flipped.toggle())
                        }
                        doneHandler($0, $1)
                    },
                    deleteHandler: deleteHandler)
            }
        )
        .shadow(radius: 20)
        .onAppear {
            if isNew {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                        flipped = true
                    }
                }
            }
        }
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(countdown: .placeholder, isFlipped: false, isNew: false, tapHandler: {_ in}, imageHandler: {}, doneHandler: {_, _ in}, deleteHandler: {})
                .frame(width: 400, height: 400, alignment: .center)
                .previewLayout(.sizeThatFits)

            CardView(countdown: .placeholder, isFlipped: false, isNew: false, tapHandler: {_ in}, imageHandler: {}, doneHandler: {_, _ in}, deleteHandler: {})
                .frame(width: 400, height: 400, alignment: .center)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
