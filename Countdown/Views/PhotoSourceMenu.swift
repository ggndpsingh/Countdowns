//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct PhotoSourceMenu<Label: View>: View {
    let label: () -> Label
    let action: (PhotoSource) -> Void

    var body: some View {
        Menu {
            Button(action: { action(.library) }) {
                Text("Photo Library")
                Image(systemName: "photo.on.rectangle")
            }
            Button(action: { action(.unsplash) }) {
                Text("Unsplash")
                Image("unsplashIcon")
                    .frame(width: 16, height: 16, alignment: .center)
            }
        } label: {
            label()
        }
    }
}
