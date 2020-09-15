//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
