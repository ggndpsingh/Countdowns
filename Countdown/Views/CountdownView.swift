//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct FlipView<Front: View, Back: View>: View {
    var isFlipped: Bool
    var front: () -> Front
    var back: () -> Back

    init(isFlipped: Bool, @ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
        self.isFlipped = isFlipped
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            front()
                .rotation3DEffect(.degrees(isFlipped == true ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped == true ? 0 : 1)
                .accessibility(hidden: isFlipped == true)

            back()
                .rotation3DEffect(.degrees(isFlipped == true ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped == true ? 1 : 0)
                .accessibility(hidden: isFlipped == false)
        }
    }
}

struct CountdownGridItem: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var flipped: Bool = false
    @State private var components: [DateComponent] = []

    let countdown: Countdown

    init(countdown: Countdown, flipped: Bool) {
        self.countdown = countdown
        self.components = countdown.components()
        self.flipped = flipped
    }

    var body: some View {
        FlipView(
            isFlipped: flipped,
            front:{
                ZStack(alignment: .topLeading) {
                    GeometryReader { geometry in
                        GridItemBackground(image: countdown.image, size: geometry.size)
                            .cornerRadius(24)
                        TitleView(title: countdown.title, date: countdown.dateString)
                        CountdownView(date: countdown.date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                        flipped.toggle()
                    }
                }
            }, back: {
//                GeometryReader { geometry in
                    CreateCountdownView(viewModel: .init(countdown: countdown), doneHandler: {
                        withAnimation(.spring(response: 1, dampingFraction: 0.8)) {
                            flipped.toggle()
                        }
                    })
                    .cornerRadius(24)
//                }
            }
        )
        .frame(height: 320)
        .padding()
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
                    CountdownGridItem(countdown: countdown, flipped: false)
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
                            .shadow(color: Color.black.opacity(0.8), radius: 16, x: 0, y: 0)
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

struct TitleView: View {
    let title: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.system(size: 40, weight: .medium, design: .default))
                    .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 0)
                Text(date)
                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                    .shadow(color: Color.black.opacity(0.8), radius: 8, x: 0, y: 0)
            }
        }
        .padding()
        .foregroundColor(.white)
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
                .fill(Color.blue)
                .frame(width: size.width, height: size.height, alignment: .center)
        }

//        Group {
//            if let image = image {
//                Image(image)
//                    .resizable()
//                    .frame(width: width, alignment: .center)
//                    .aspectRatio(contentMode: .fill)
//            } else {
//                Color.blue
//            }
//        }
    }
}
