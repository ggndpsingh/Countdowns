//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.system(size: 36, weight: .medium, design: .rounded))
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
            Text(component.label)
                .font(Font.system(size: 12, weight: .regular, design: .rounded))
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
        }
        .padding(.horizontal, 4)
        .cornerRadius(8)
    }
}

#if DEBUG
struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownContainer(hasEnded: false) {
            CardFrontView(countdown: .init(id: .init(), date: Date().addingTimeInterval(3600 * 3600), title: "Past", image: .randomSample), style: .thumbnail, flipHandler: {})
        }
        .frame(width: 340, height: 320, alignment: .center)
        .previewLayout(.sizeThatFits)
    }
}
#endif
