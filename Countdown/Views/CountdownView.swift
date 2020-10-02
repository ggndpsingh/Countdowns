//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct CountdownView: View {
    private static let componentWidth: CGFloat = 70
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let date: Date
    let size: CountdownSize
    private var hasEnded: Bool { date <= .now }

    @State private var components: [DateComponent] = []

    var body: some View {
        GeometryReader { geometry in
            let canFit: Bool = {
                guard components.count > 3 else { return true }
                return Int(ceil(geometry.size.width / Self.componentWidth)) > components.count
            }()

            CountdownContainer(hasEnded: hasEnded) {
                Group {
                    if canFit {
                        ForEach(components, id: \.self) {
                            ComponentView(component: $0)
                        }
                    } else {
                        VStack {
                            HStack {
                                ForEach(components.prefix(3), id: \.self) {
                                    ComponentView(component: $0)
                                }
                            }
                            HStack {
                                ForEach(components.suffix(components.count - 3), id: \.self) {
                                    ComponentView(component: $0)
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .onAppear(perform: countdown)
        .onReceive(timer) { _ in
            countdown()
        }
    }

    private func countdown() {
        components = CountdownCalculator.countdown(for: date, size: size)
    }
}

#if DEBUG
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownContainer(hasEnded: false) {
                CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(3600 * 3600), title: "Past", image: UIImage(named: "christmas")), style: .thumbnail, flipHandler: {})
            }
            .frame(width: 340, height: 320, alignment: .center)
            .previewLayout(.sizeThatFits)

            CountdownContainer(hasEnded: true) {
                CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(-3600), title: "Past", image: UIImage(named: "christmas")), style: .thumbnail, flipHandler: {})
            }
            .frame(width: 400, height: 320, alignment: .center)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
