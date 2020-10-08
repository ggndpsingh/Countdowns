//  Created by Gagandeep Singh on 8/10/20.

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let url = URL(string: "https://apps.apple.com/app/id533625910")!
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
