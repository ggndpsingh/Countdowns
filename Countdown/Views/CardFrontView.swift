//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown

    var body: some View {
        ZStack(alignment: .topLeading) {
            CardBackground(imageURL: countdown.image)
                .overlay(Rectangle().fill(Color.black.opacity(0.3)))
            TitleView(title: countdown.title, date: countdown.dateString)
            CountdownView(date: countdown.date, size: .medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: 16)
        }
        .cornerRadius(24)
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1565700430899-1c56a5cf64e3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
    }
}
