//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct CountdownView: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let date: Date
    let size: CountdownSize
    private var hasEnded: Bool { date <= .now }

    @State private var components: [DateComponent] = []

    var body: some View {
        CountdownContainer(hasEnded: hasEnded) {
            ForEach(components, id: \.self) {
                ComponentView(component: $0)
            }
        }
        .onAppear(perform: countdown)
        .onReceive(timer) { _ in
            countdown()
        }
    }

    private func countdown() {
        components = CountdownCalculator.countdown(for: date)
    }
}

#if DEBUG
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(-3600), title: "Past", image: UIImage(named: "christmas")))
                .frame(width: 400, height: 320, alignment: .center)
                .previewLayout(.sizeThatFits)
            CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(3600), title: "Past", image: UIImage(named: "christmas")))
                .frame(width: 400, height: 320, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
