//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack {
            Text(component.valueString)
                .font(Font.dank(size: 36))
            Text(component.label)
                .font(Font.dank(size: 12))
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 12)
        .cornerRadius(8)
    }
}
