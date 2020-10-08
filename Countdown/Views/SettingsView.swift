//  Created by Gagandeep Singh on 7/10/20.

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var toggle = PreferenceToggle.shared
    @State private var showGetPremium: Bool = false
    @State private var showShareSheet: Bool = false
    let closeHandler: () -> Void

    private var showPremium: Bool { showGetPremium || toggle.showGetPremium }

    fileprivate func preferenceItem(text: String, image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: image)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                Text(text)
                    .font(.system(size: 16, weight: .regular, design: .default))
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
        .buttonStyle(SquishableButtonStyle())
    }

    var body: some View {
        ZStack {
            Color.systemBackground
                .edgesIgnoringSafeArea(.all)

            GeometryReader { geo in
                VStack(spacing: 0) {
                    navigation

                    if (!showPremium) {
                        VStack {
                            preferences

                            Spacer()

                            if !PurchaseManager.shared.hasPremium {
                                premiumButton
                            }
                        }
                        .padding(24)
                        .transition(.moveAndFadeTop)
                    }

                    if (showPremium) {
                        GetPremiumView(closeHandler: handleClose)
                    }
                }
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var preferences: some View {
        VStack(alignment: .leading, spacing: 16) {
            preferenceItem(text: "Reminders", image: "bell") {

            }

            Divider()

            preferenceItem(text: "About", image: "clock.arrow.circlepath") {

            }

            Divider()

            preferenceItem(text: "Rate Countdowns", image: "star") {

            }

            Divider()

            preferenceItem(text: "Share Countdowns", image: "square.and.arrow.up") {
                showShareSheet = true
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet()
        }
        .font(.system(size: 16, weight: .regular, design: .default))
    }

    private var navigation: some View {
        ZStack {
            Text(showPremium ? "Countdowns Premium" : "Preferences")
                .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                RoundButton(action: handleClose, image: "xmark", color: .secondary)
                    .rotationEffect(.degrees(showPremium ? 180 : 0))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .font(.system(size: 16, weight: .medium, design: .default))
    }

    private var premiumButton: some View {
        Button(action: {
            withAnimation(.openCard) {
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
        .buttonStyle(SquishableButtonStyle())
    }

    private func handleClose() {
        withAnimation(.closeCard) {
            if showGetPremium {
                showGetPremium = false
            } else {
                closeHandler()
            }
        }
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
