//  Created by Gagandeep Singh on 7/10/20.

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var toggle = PreferenceToggle.shared
    @State private var showGetPremium: Bool = false
    let closeHandler: () -> Void

    fileprivate func preferenceItem(text: String, image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                Text(text)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            .font(.system(size: 16, weight: .regular, design: .default))
            .padding()
            .background(Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.05))
            .cornerRadius(8)
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
    }

    var body: some View {
        ZStack {
            Color.systemBackground
                .edgesIgnoringSafeArea(.all)

            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 36) {
                    ZStack {
                        Text("Preferences")
                            .frame(maxWidth: .infinity)

                        HStack {
                            Spacer()
                            RoundButton(action: closeHandler, image: "xmark", color: .secondaryLabel)
                        }
                    }
                    .font(.system(size: 16, weight: .medium, design: .default))

                    VStack(alignment: .leading, spacing: 16) {
                        preferenceItem(text: "Reminders", image: "bell") {

                        }

                        preferenceItem(text: "About", image: "clock.arrow.circlepath") {

                        }

                        preferenceItem(text: "Rate App", image: "star") {

                        }

                        preferenceItem(text: "Share Countdowns", image: "square.and.arrow.up") {

                        }
                    }

                    Spacer()

                    if !PurchaseManager.shared.hasPremium {
                        Button(action: {
                            withAnimation(.flipCard) {
                                showGetPremium = true
                            }
                        }) {
                            Text("Upgrade to Premium")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .frame(maxWidth:.infinity)
                                .padding(.vertical)
                                .background(Color.primary)
                                .foregroundColor(.systemBackground)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(24)
                .padding(.vertical, 40)
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .regular, design: .default))
                .offset(y: (showGetPremium || toggle.showGetPremium) ? -geo.size.height : 0)

                if !PurchaseManager.shared.hasPremium {
                    GetPremiumView(closeHandler: {
                        withAnimation(.closeCard) {
                            if showGetPremium {
                                showGetPremium = false
                            } else {
                                toggle.close()
                            }
                        }
                    })
                    .accessibility(hidden: !showGetPremium)
                    .offset(y: (showGetPremium || toggle.showGetPremium) ? 0 : geo.size.height)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var show: Bool = false
    static var previews: some View {
        Group {
            SettingsView(closeHandler: {})
            SettingsView(closeHandler: {})
                .preferredColorScheme(.dark)
        }
    }
}
