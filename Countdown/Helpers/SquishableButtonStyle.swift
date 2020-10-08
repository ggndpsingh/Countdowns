//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

struct SquishableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}
