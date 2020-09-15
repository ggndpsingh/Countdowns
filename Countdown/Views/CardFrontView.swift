//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardFrontView: View {
    @State private var deleteAlertPresented: Bool = false
    let countdown: Countdown
    let deleteHandler: (UUID) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                CardBackground(image: countdown.image, blur: false, size: geometry.size)

                HStack(alignment: .top) {
                    TitleView(title: countdown.title, date: countdown.dateString)
                    Spacer()
                    HStack {
                        Button(action: {
                            deleteAlertPresented = true
                        }, label: {
                            Image(systemName: "trash")
                                .frame(width: 36, height: 36)
                                .background(Circle().fill(Color.white.opacity(0.7)))
                                .foregroundColor(.red)
                        })
                    }
                    .font(.subheadline)
                }
                .padding()
                CountdownView(date: countdown.date)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .alert(isPresented: $deleteAlertPresented) {
            Alert(
                title: Text("Delete Countdown"),
                message: Text("Are you sure you want to delete this countdown?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteHandler(countdown.id)
                }, secondaryButton: .cancel(Text("Cancel")))
        }
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "apple"), deleteHandler: {_ in})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()
    }
}
