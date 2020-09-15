//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct CountdownGridItem: View {
    @State var flipped: Bool = false
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
                ZStack(alignment: .topLeading) {
                    CountdownCardFrontView(countdown: countdown, deleteHandler: deleteHandler)
                }
                .onAppear {
                    if isNew {
                        withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                            flipped.toggle()
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                        flipped.toggle()
                    }
                }
            }, back: {
                CreateCountdownView(
                    viewModel: .init(countdown: countdown),
                    doneHandler: handleDone,
                    cancelHandler: handleCancel)
                    .cornerRadius(24)
            }
        )
        .frame(height: 320)
        .padding()
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

struct CountdownView_Previews: PreviewProvider {
    static let preview: ScrollView = {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 400, maximum: 600))], spacing: 0) {
                ForEach([
                    Countdown(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Wedding", image: "wedding"),
                    Countdown(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Honeymoon", image: "sweden"),
                    Countdown(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Random", image: nil)
                ]) { countdown in
                    CountdownGridItem(countdown: countdown, isNew: false, doneHandler: {_ in}, cancelHandler: {_ in}, deleteHandler: {_ in})
                }
            }
        }
    }()
    static var previews: some View {
        Group {
            Self.preview
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            Self.preview
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            Self.preview
        }
    }
}

struct CountdownView: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let date: Date
    private var hasEnded: Bool { date <= .now }

    @State private var components: [DateComponent] = []

    var body: some View {
        Group {
            if hasEnded {
                Text("Countdow Ended")
                    .font(.title)
            } else {
                HStack(spacing: 16) {
                    ForEach(components, id: \.self) {
                        ComponentView(component: $0)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
                    }
                }
                .onAppear(perform: countdown)
                .onReceive(timer) { _ in
                    countdown()
                }
            }
        }
    }

    private func countdown() {
        components = CountdownCalculator.shared.countdown(for: date, size: .medium)
    }
}

struct GridItemBackground: View {
    let image: String?
    let size: CGSize

    var body: some View {
        if let image = image {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height, alignment: .center)
                .clipped()
                .cornerRadius(24)
        } else {
            Rectangle()
                .fill(Color.yellow)
                .frame(width: size.width, height: size.height, alignment: .center)
        }    }
}
