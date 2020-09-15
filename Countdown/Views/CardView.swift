//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardView: View {
    @State private var flipped: Bool = false
    let countdown: Countdown
    let isNew: Bool
    let doneHandler:  (Countdown) -> Void
    let cancelHandler: (UUID) -> Void
    let deleteHandler: (UUID) -> Void

    internal init(
        countdown: Countdown,
        isNew: Bool,
        doneHandler: @escaping (Countdown) -> Void,
        cancelHandler: @escaping (UUID) -> Void,
        deleteHandler: @escaping (UUID) -> Void) {

        self.countdown = countdown
        self.isNew = isNew
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        FlipView(
            isFlipped: flipped,
            front:{
                CardFrontView(
                    countdown: countdown,
                    deleteHandler: deleteHandler)
                    .onAppear(perform: flipIfNew)
                    .onTapGesture(perform: flip)
            }, back: {
                CardBackView(
                    viewModel: .init(
                        countdown: countdown),
                    doneHandler: handleDone,
                    cancelHandler: handleCancel)
                    .cornerRadius(24)
            }
        )
        .frame(height: 320)
        .padding()
    }

    private func flip() {
        withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
            flipped.toggle()
        }
    }

    private func flipIfNew() {
        if isNew {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.flip()
            }
        }
    }

    private func handleDone(countdown: Countdown) {
        doneHandler(countdown)
        withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
            flipped.toggle()
        }
    }

    private func handleCancel(id: UUID) {
        cancelHandler(countdown.id)
        withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
            flipped.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "apple"), isNew: false, doneHandler: { _ in }, cancelHandler: { _ in }, deleteHandler: { _ in })
    }
}
