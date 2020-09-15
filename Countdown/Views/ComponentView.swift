//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct ComponentView: View {
    let component: DateComponent

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(String(component.value))
                .font(Font.system(size: 48, weight: .medium, design: .monospaced))
            Text(component.label)
                .font(.subheadline)
        }
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView(component: .year(2))
            .background(Color.blue)
    }
}
