//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct TitleView: View {
    let title: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.system(size: 40, weight: .medium, design: .default))
                    .shadow(color: Color.black.opacity(0.3), radius: 0, x: 1, y: 1)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 0)
                Text(date)
                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                    .shadow(color: Color.black.opacity(0.3), radius: 0, x: 1, y: 1)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 0)
            }
        }
        .foregroundColor(.white)
    }
}

struct TitleView_Previews: PreviewProvider {
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
