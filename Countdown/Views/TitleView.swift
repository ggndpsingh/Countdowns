//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct TitleView: View {
    let title: String
    let date: String
    let showDate: Bool

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.system(size: 28, weight: .medium, design: .default))

                    if showDate {
                        Text(date)
                            .font(Font.system(size: 16, weight: .medium, design: .default))
                    }
                }
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding([.top], 24)
            .padding(.horizontal, 16)
        }
        .frame(alignment: .topLeading)
        .foregroundColor(.white)
    }
}

#if DEBUG
//struct TitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(3600 * 3600), title: "Past", image: .randomSample), style: .thumbnail, flipHandler: {})
//        .frame(width: 340, height: 320, alignment: .center)
//        .previewLayout(.sizeThatFits)
//    }
//}
#endif
