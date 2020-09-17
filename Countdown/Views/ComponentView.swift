//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.system(size: 32, weight: .medium, design: .monospaced))
            Text(component.label)
                .font(Font.system(size: 10, weight: .medium, design: .default))
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 12)
        .background(Color.systemBackground.opacity(0.5))
        .foregroundColor(.label)
        .cornerRadius(8)
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1600173220698-9dddbbd35fb3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()

    }
}
