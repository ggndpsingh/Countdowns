//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.dank(size: 36))
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
            Text(component.label)
                .font(Font.dank(size: 12))
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
        }
        .padding(.horizontal, 4)
        .cornerRadius(8)
    }
}

#if DEBUG
struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(countdown: .preview, style: .thumbnail, flipHandler: {})
    }
}
#endif
