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
        Group {
            if hasEnded {
                Text("Countdow Ended")
                    .font(.title)
            } else {
                HStack(spacing: 8) {
                    ForEach(components, id: \.self) {
                        ComponentView(component: $0)
                    }
                }
                .onAppear(perform: countdown)
                .onReceive(timer) { _ in
                    countdown()
                }
            }
        }
        .foregroundColor(.white)
    }

    private func countdown() {
        components = CountdownCalculator.countdown(for: date, size: .medium)
    }
}
