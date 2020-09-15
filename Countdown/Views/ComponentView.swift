//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(String(component.value))
                .font(Font.system(size: 48, weight: .medium, design: .monospaced))
            Text(component.label)
                .font(.subheadline)
        }
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct ComponentView_Previews: PreviewProvider {
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
