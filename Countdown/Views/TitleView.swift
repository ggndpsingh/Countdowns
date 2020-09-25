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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, idealHeight: 70, maxHeight: 70, alignment: .top)
        .foregroundColor(.white)
    }
}
