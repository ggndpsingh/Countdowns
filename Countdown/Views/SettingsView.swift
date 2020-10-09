//  Created by Gagandeep Singh on 7/10/20.

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var toggle = PreferenceToggle.shared
    @State private var showGetPremium: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var isLoading = false
    @State private var product: SKProduct?

    private var showPremium: Bool {
        showGetPremium || toggle.showGetPremium
    }
    private var price: String? {
        guard let product = product else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = product.priceLocale
        formatter.numberStyle = .currency
        return formatter.string(from: product.price)
    }

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
        ZStack(alignment: .bottom) {
            Color.systemBackground
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                navigation

                if (showPremium) {
                    GetPremiumView(closeHandler: handleClose)
                } else {
                    preferences
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            if showPremium {
                gradient.edgesIgnoringSafeArea(.bottom)
            }
            premiumButton
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear(perform: loadProduct)
    }

    private var preferences: some View {
        VStack(alignment: .leading, spacing: 16) {
            preferenceItem(text: "Reminders", image: "bell.fill") {

            }

            Divider()

            preferenceItem(text: "About", image: "info.circle.fill") {

            }

            Divider()

            preferenceItem(text: "Rate Countdowns", image: "star.fill") {
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                SKStoreReviewController.requestReview(in: scene)
            }

            Divider()

            preferenceItem(text: "Share Countdowns", image: "square.and.arrow.up.fill") {
                showShareSheet = true
            }
        }
        .padding(24)
        .font(.system(size: 16, weight: .regular, design: .default))
        .sheet(isPresented: $showShareSheet) {
            ShareSheet()
        }
    }

    private var navigation: some View {
        return ZStack {
            VStack {
                Text("Preferences")
                    .frame(height: 60)
                    .offset(y: showPremium ? -30 : 30)
                Text("Countdowns Premium")
                    .frame(height: 60)
                    .offset(y: showPremium ? -30 : 30)
            }
            .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                RoundButton(action: handleClose, image: "xmark", color: .secondary)
                    .rotationEffect(.degrees(showPremium ? 180 : 0))
            }
        }
        .padding(24)
        .frame(height: 60)
        .font(.system(size: 16, weight: .medium, design: .default))
        .clipped()
    }

    private var premiumButton: some View {
        Button(action: {
            if showPremium {
                buyPremium()
            } else {
                withAnimation(.openCard) {
                    showGetPremium = true
                }
            }
        }) {
            ZStack {
                VStack {
                    Text("Upgrade to Premium")
                        .frame(maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60)
                        .offset(y: showPremium ? -30 : 30)
                    Text(isLoading ? "" : "Buy for \(price ?? "")")
                        .frame(maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60)
                        .offset(y: showPremium ? -30 : 30)
                }
                .font(.system(size: 16, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60)
                .background(Color.primary)
                .foregroundColor(.systemBackground)
                .cornerRadius(8)
                .padding()
                .clipped()

                let colors = Gradient(colors: [.clear, .systemBackground])
                let conic = AngularGradient(gradient: colors, center: .center, startAngle: .zero, endAngle: .degrees(270))
                Circle()
                    .strokeBorder(conic, lineWidth: 3)
                    .rotationEffect(.init(degrees: isLoading ? 360 : 0))
                    .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding()
                    .opacity(isLoading ? 1 : 0)
            }
        }
        .padding(.bottom, 24)
        .buttonStyle(SquishableButtonStyle())
    }

    private var gradient: some View {
        LinearGradient(gradient: .init(colors: [.systemBackground, Color.systemBackground.opacity(0)]), startPoint: .bottom, endPoint: .top)
            .frame(height: 120)
            .edgesIgnoringSafeArea(.bottom)
    }

    private func handleClose() {
        withAnimation(.closeCard) {
            if showGetPremium {
                showGetPremium = false
            } else {
                toggle.close()
            }
        }
    }

    private func buyPremium() {
        guard let product = product else { return }
        withAnimation(.easeIn) {
            isLoading = true
        }
        PurchaseManager.shared.buyProduct(product) { success in
            withAnimation(.easeIn) {
                isLoading = false
                if success {
                    handleClose()
                }
            }
        }
    }

    func loadProduct() {
        PurchaseManager.shared.requestProduct { self.product = $0 }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var show: Bool = false
    static var previews: some View {
        Group {
            SettingsView()
            SettingsView()
                .preferredColorScheme(.dark)
        }
    }
}
