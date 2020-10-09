//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

struct CountdownView: View {
    @Environment(\.timer) var timer
    private static let componentWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 64 : 48
    @State private var components: [DateComponent] = []

    let date: Date
    let size: CountdownSize
    let animate: Bool
    private var hasEnded: Bool { date <= .now }
    private var isiPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        GeometryReader { geometry in
            let canFit: Bool = {
                guard components.count > 3 else { return true }
                let requiredWidth = (Self.componentWidth + 24) * CGFloat(components.count)
                return geometry.size.width > requiredWidth
            }()

            CountdownContainer(hasEnded: hasEnded) {
                Group {
                    if canFit {
                        VStack {
                            values(for: components)
                            labels(for: components)
                        }
                    } else {
                        VStack(spacing: 8) {
                            HStack {
                                let comps = Array(components.prefix(3))
                                VStack {
                                    values(for: comps)
                                    labels(for: comps)
                                }
                            }
                            HStack {
                                let comps = Array(components.suffix(components.count - 3))
                                VStack {
                                    values(for: comps)
                                    labels(for: comps)
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .onAppear(perform: countdown)
        .onReceive(timer) { _ in
            countdown()
        }
    }

    private func values(for components: [DateComponent]) -> some View {
        HStack(spacing: 8) {
            ForEach(components, id: \.self) {
                value(for: $0)
            }
        }
        .animation(animate ? .linear(duration: 0.7) : nil, value: components)
        .clipShape(Rectangle())
        .clipped()
    }

    private func value(for component: DateComponent) -> some View {
        Text(component.valueString)
            .font(Font.system(size: isiPad ? 48 : 36, weight: .medium, design: .rounded))
            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0.5, y: 0.5)
            .frame(width: Self.componentWidth)
            .clipShape(Rectangle())
            .clipped()
            .transition(.moveAndFadeVertical)
    }

    private func labels(for components: [DateComponent]) -> some View {
        return HStack {
            ForEach(components, id: \.self) {
                label(for: $0)
            }
        }
    }

    private func label(for component: DateComponent) -> some View {
        Text(component.label)
            .font(Font.system(size: isiPad ? 14 : 12, weight: .medium, design: .rounded))
            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 0.5, y: 0.5)
            .frame(width: Self.componentWidth)
    }

    private func countdown() {
        components = CountdownCalculator.countdown(for: date, size: size)
    }
}

#if DEBUG
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownView(date: Date().addingTimeInterval(3600 * 3600 * 36), size: .full, animate: true)
                .background(Color.pastels.randomElement())
            CountdownView(date: Date().addingTimeInterval(3600 * 3600 * 36), size: .medium, animate: true)
                .background(Color.pastels.randomElement())
        }
    }
}
#endif
