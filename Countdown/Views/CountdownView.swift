//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct CountdownGridItem: View {
    let viewState: ViewState

    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { _ in
                GridItemBackground(image: viewState.image)
                TitleView(title: viewState.title, date: viewState.date)
                CountdownView(components: viewState.components, hasEnded: viewState.hasEnded)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
        }
        .frame(height: 360)
        .cornerRadius(24)
        .padding()
    }

    struct ViewState: Identifiable {
        let id: NSManagedObjectID
        let title: String
        let date: String
        let components: [DateComponent]
        let image: String?
        let hasEnded: Bool

        init(countdown: CountdownItem) {
            self.id = countdown.objectID
            title = countdown.title
            date = countdown.dateString
            components = countdown.components(size: .full, trimmed: true)
            image = countdown.image
            hasEnded = countdown.hasEnded
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static let preview: ScrollView = {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 400, maximum: 600))], spacing: 0) {
                ForEach([
                    CountdownItem.create(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Wedding", image: "wedding"),
                    CountdownItem.create(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Honeymoon", image: "sweden"),
                    CountdownItem.create(date: Date().addingTimeInterval((3600 * 24 * 7 * 53)), title: "Random", image: nil)
                ]) { countdown in
                    CountdownGridItem(viewState: .init(countdown: countdown))
                }
            }
        }
    }()
    static var previews: some View {
        Group {
            Self.preview
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            Self.preview
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            Self.preview
        }
    }
}

struct CountdownView: View {
    let components: [DateComponent]
    let hasEnded: Bool
    var body: some View {
        Group {
            if hasEnded {
                Text("Countdow Ended")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            } else {
                HStack(spacing: 16) {
                    ForEach(components, id: \.self) {
                        ComponentView(component: $0)
                    }
                }
            }
        }
    }
}

struct TitleView: View {
    let title: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.largeTitle)
                Text(date)
                    .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(.white)
        .shadow(color: Color.black.opacity(0.4), radius: 0, x: 1, y: 1)
    }
}

struct GridItemBackground: View {
    let image: String?

    var body: some View {
        Group {
            if let image = image {
                Image(image)
                    .resizable()
                    .frame(alignment: .center)
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.blue
            }
        }
    }
}
