//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.system(size: 36, weight: .medium, design: .monospaced))
            Text(component.label)
                .font(Font.system(size: 12, weight: .medium, design: .default))
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 12)
        .cornerRadius(8)
    }
}
