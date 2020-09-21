//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    let countdown: Countdown

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(imageURL: countdown.image, size: geometry.size)
                    .overlay(Rectangle().fill(Color.black.opacity(0.3)))
                TitleView(title: countdown.title, date: countdown.dateString)
                CountdownView(date: countdown.date, size: .medium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 16)
            }
        }
        .cornerRadius(24)
    }
}
