//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent
    private var isiPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.system(size: isiPad ? 48 : 36, weight: .medium, design: .rounded))
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
            Text(component.label)
                .font(Font.system(size: isiPad ? 14 : 12, weight: .medium, design: .rounded))
                .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
        }
        .padding(.horizontal, 4)
        .cornerRadius(8)
    }
}

#if DEBUG
struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(date: Date().addingTimeInterval(3600 * 3600), size: .full, animate: true)
            .background(Color.pastels.randomElement())
    }
}
#endif
