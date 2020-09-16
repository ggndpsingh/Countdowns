//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(imageURL: countdown.image, blur: false, size: geometry.size)
                VStack(spacing: 0) {
                    TitleView(title: countdown.title, date: countdown.dateString)
                    CountdownView(date: countdown.date)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(y: -12)
                }
            }
        }
        .cornerRadius(24)
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
                .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
        }
        .padding()
    }
}
