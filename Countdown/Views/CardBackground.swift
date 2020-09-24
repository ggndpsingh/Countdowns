//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackground: View {
    let imageURL: String?

    var body: some View {
        ImageView(path: imageURL!)
            .cornerRadius(24)
            .contentShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .clipped(antialiased: false)
    }
}


struct CardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"))
            
            CardBackView(viewModel: .init(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1600017751108-6df9a5a7334e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"), countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), doneHandler: {_ in }, deleteHandler: {})
        }
    }
}
