//  Created by Gagandeep Singh on 29/9/20.

import SwiftUI

struct EmptyListView: View {
    let createEventHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            CardFrontView(countdown: .preview, style: .thumbnail, flipHandler: {})
                .contentShape(Rectangle())
                .aspectRatio(1, contentMode: .fit)
                .redacted(reason: .placeholder)
                .frame(maxWidth: 360)

            Text("You have not created any events yet.")
                .font(Font.system(size: 16, weight: .regular, design: .default))
                .padding(.top, 24)

            Button(action: createEventHandler) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create an event")
                }
                .foregroundColor(Color.systemBackground)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.primary)
                .clipShape(Capsule())
            }
            .buttonStyle(SquishableButtonStyle())

        }
        .padding()
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(createEventHandler: {})
    }
}
