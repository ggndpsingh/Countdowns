//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct TitleView: View {
    let title: String
    let date: String

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.system(size: 24, weight: .regular, design: .default))
                    Text(date)
                        .font(Font.system(size: 12, weight: .regular, design: .rounded))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, idealHeight: 70, maxHeight: 70, alignment: .top)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Indian Date Night! 🍎", image: "https://images.unsplash.com/photo-1600173220698-9dddbbd35fb3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Indian Date Night!", image: "https://images.unsplash.com/photo-1600173220698-9dddbbd35fb3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
            }
            .preferredColorScheme(.dark)
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()

    }
}
