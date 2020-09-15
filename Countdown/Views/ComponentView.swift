//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.system(size: 48, weight: .medium, design: .monospaced))
            Text(component.label)
                .font(.caption)
        }
        .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
        .padding(4)
        .background(Color.white.opacity(0.3))
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
