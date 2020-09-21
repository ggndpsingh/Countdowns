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


struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test 🍎", image: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()

    }
}
