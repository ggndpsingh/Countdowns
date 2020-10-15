//  Created by Gagandeep Singh on 7/10/20.

import SwiftUI
import StoreKit

extension UIApplication {
    var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.settings) var settings
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

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Color.systemBackground
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    navigation

                    if (showPremium) {
                        GetPremiumView(freeEventsExhausted: toggle.showGetPremium, product: product, closeHandler: handleClose)
                    } else {
                        preferences
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                if showPremium {
                    gradient.edgesIgnoringSafeArea(.bottom)
                }

                if !PurchaseManager.shared.hasPremium {
                    premiumButton
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(minWidth: 360, idealWidth: 400, maxWidth: 480, maxHeight: .infinity)
            .onAppear(perform: loadProduct)
        }
        .transition(.preferences)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .zIndex(3)
    }

    private var preferences: some View {
        Form {
            Section {
                Toggle(isOn: settings.showSeconds, label: {
                    preferenceItemLabel(text: "Display seconds", image: "clock.fill")
                })
            }

            Section {
                preferenceItem(text: "Rate Countdowns", image: "star.fill") {
                    guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                    SKStoreReviewController.requestReview(in: scene)
                }

                preferenceItem(text: "Share Countdowns", image: "square.and.arrow.up.fill") {
                    showShareSheet = true
                }

                socialButtons
            }
        }
        .font(.system(size: 16, weight: .regular, design: .default))
        .sheet(isPresented: $showShareSheet) {
            ShareSheet()
        }
    }

    private func preferenceItem(text: String, image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            preferenceItemLabel(text: text, image: image)
        }
        .buttonStyle(SquishableButtonStyle())
    }

    private func preferenceItemLabel(text: String, image: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: image)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundColor(.secondary)
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .default))
        }
        .frame(maxWidth:.infinity, alignment: .leading)
        .padding(.vertical, 4)
    }

    private var socialButtons: some View {
        func makeButton(image: Image, url: String) -> some View {
            Button(action: {
                UIApplication.shared.open(URL(string: url)!, options: [.universalLinksOnly: false], completionHandler: nil)
            }, label: {
                image
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .padding(8)
            })
        }

        return HStack(spacing: 8) {
            makeButton(image: Image("twitter"), url: "https://twitter.com/GetCountdowns")
            makeButton(image: Image("instagram"), url: "https://instagram.com/getcountdowns")
        }
        .foregroundColor(.secondary)
        .padding(.vertical)
        .offset(x: -8)
        .frame(maxWidth: .infinity, alignment: .leading)
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
                        .frame(maxWidth: .infinity, minHeight: 54, idealHeight: 54, maxHeight: 54)
                        .offset(y: showPremium ? -27 : 27)
                    Text(isLoading ? "" : "Buy for \(price ?? "")")
                        .frame(maxWidth: .infinity, minHeight: 54, idealHeight: 54, maxHeight: 54)
                        .offset(y: showPremium ? -27 : 27)
                }
                .font(.system(size: 16, weight: .medium, design: .default))
                .frame(maxWidth: .infinity, minHeight: 54, idealHeight: 54, maxHeight: 54)
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
        if showGetPremium {
            withAnimation(.closeCard) {
                showGetPremium = false
            }
        } else {
            withAnimation(.togglePreferences) {
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
