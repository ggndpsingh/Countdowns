//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CountdownCardFrontView: View {
    let countdown: Countdown
    let deleteHandler: (UUID) -> Void

    var body: some View {
        GeometryReader { geometry in
            GridItemBackground(image: countdown.image, size: geometry.size)
                .cornerRadius(24)
            HStack(alignment: .top) {
                TitleView(title: countdown.title, date: countdown.dateString)
                Spacer()
                HStack {
                    Button(action: {
                        deleteHandler(countdown.id)
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
}

struct CountdownCardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CountdownCardFrontView(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test"), deleteHandler: {_ in})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()
    }
}

struct TitleView: View {
    let title: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.system(size: 40, weight: .medium, design: .default))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 0)
                Text(date)
                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 0)
            }
        }
        .foregroundColor(.white)
    }
}
