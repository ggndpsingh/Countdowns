//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct CountdownView: View {
    let countdown: CountdownItem
    let tapHandler: ((CountdownItem) -> Void)
    @State private var timer: Timer?
    @State private var components: [DateComponent] = []

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 4) {
                Text(countdown.title)
                    .font(.headline)
                Text(countdown.dateString)
                    .font(.caption)
            }

            Divider()

            if countdown.hasEnded {
                Text("Countdow Ended")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            } else {
                HStack(spacing: 16) {
                    ForEach(components, id: \.self) {
                        ComponentView(component: $0)
                    }
                }
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .onAppear { startCountdown() }
        .onDisappear { pauseCountdown() }
        .onTapGesture { tapHandler(countdown) }
    }

    private func startCountdown() {
        guard !countdown.hasEnded else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            components = countdown.components
        })
        timer?.fire()
    }

    private func pauseCountdown() {
        timer?.invalidate()
    }
}

//struct CountdownView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountdownView(countdown: .init(
//            title: "US Presidential Elections",
//            date: {
//                let string = "04-11-2020 00:00:00"
//                return CountdownCalculator.shared.dateToCountdownFomatter.date(
//                    from: string)!
//            }()
//        ))
//    }
//}
