//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

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
                            .shadow(color: Color.black.opacity(0.5), radius: 0, x: 1, y: 1)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 0)
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


struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "apple"), deleteHandler: {_ in})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()

    }
}
