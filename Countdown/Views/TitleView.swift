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
                        .font(Font.system(size: 24, weight: .medium, design: .rounded))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding([.top], 24)
            .padding(.horizontal, 16)
        }
        .frame(alignment: .topLeading)
        .foregroundColor(.white)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(countdown: .preview)
            .frame(width: 360, height: 320)
            .previewLayout(.sizeThatFits)
    }
}
