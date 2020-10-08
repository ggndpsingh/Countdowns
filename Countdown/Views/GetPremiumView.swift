//  Created by Gagandeep Singh on 2/10/20.

import SwiftUI
import StoreKit

struct GetPremiumView: View {
    @Environment(\.colorScheme) private var colorScheme
    let closeHandler: () -> Void
    @State private var product: SKProduct?
    @State var isLoading = false

    private var price: String? {
        guard let product = product else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = product.priceLocale
        formatter.numberStyle = .currency
        return formatter.string(from: product.price)
    }

    private var buttonText: String {
        isLoading
            ? ""
            : "Buy for \(price ?? "")"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 40) {
                        header
                        description
                            .padding(.vertical, 40)
                        featuresList

                        faq.padding(.bottom, 100)
                    }
                    .padding([.top], 40)
                    .padding(24)
                }
                .onAppear(perform: loadProduct)
            }

            buyButton
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private var header: some View {
        VStack(alignment: .center, spacing: 8) {
            Image("icon")
                .resizable()
                .frame(width: 80, height: 80, alignment: .center)
                .cornerRadius(16)
                .shadow(radius: 10)

            HStack(alignment: .top, spacing: 4) {
                Text("Countdowns")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .padding(.vertical, 4)

                Text("Premium")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.primary)
                    .foregroundColor(.systemBackground)
                    .cornerRadius(4)
            }
        }
    }

    private var description: some View {
        VStack {
            Text("Upgrade to Countdowns Permium\nto unlock even more features with a\n")
            + Text("one-time purchase ")
                .font(.system(size: 16, weight: .semibold, design: .default))
            + Text("of \(price ?? "")")
        }
        .multilineTextAlignment(.center)
        .font(.system(size: 16, weight: .regular, design: .default))
        .lineSpacing(4)
    }

    private var featuresList: some View {
        let features: [String] = [
            "Unlimited events", "Add any event to a Widget", "No watermark"
        ]

        return VStack(alignment: .leading, spacing: 12) {
            Text("What you get with Premium?")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding([.bottom], 4)

            ForEach(features, id: \.self) { feature in
                HStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                    Text(feature)
                        .font(.system(size: 16, weight: .regular, design: .default))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.05))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 14, weight: .regular, design: .default))
    }

    private var faq: some View {
        let sets: [(String, String)] = [
            ("What am I paying for?", "By purchasing Countdowns Premium, you become a Premium member and have access to all the features listed above and any Premium features added in the future."),
            ("Will I have to pay again?", "No! This is a one-time purchase. You will never have to pay for this again."),
            ("I have already purchased Countdowns Premium", "Thank You! You can restore your purchase below.")
        ]

        return VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(0..<sets.count) { i in
                    let (question, answer)  = sets[i]
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                        Text(answer)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .lineSpacing(4)
                    }
                }
            }
            .padding(.top, 64)
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: restorePurchase, label: {
                Text("Restore")
                    .underline()
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium, design: .default))
            })
        }
    }

    private var buyButton: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: .init(colors: [.systemBackground, Color.systemBackground.opacity(0)]), startPoint: .bottom, endPoint: .top)
            Button(action: buyPremium) {
                ZStack {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .frame(maxWidth:.infinity)
                        .padding(.vertical)
                        .background(Color.primary)
                        .foregroundColor(.systemBackground)
                        .cornerRadius(8)
                        .padding(24)

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
            .buttonStyle(SquishableButtonStyle())
        }
        .frame(height: 120)
        .edgesIgnoringSafeArea(.bottom)
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
                    closeHandler()
                }
            }
        }
    }

    private func restorePurchase() {
        PurchaseManager.shared.restorePurchases()
    }

    func loadProduct() {
        PurchaseManager.shared.requestProduct { self.product = $0 }
    }
}

struct GetPremiumView_Previews: PreviewProvider {
    @State static var presenting: Bool = true

    static var previews: some View {
        Group {
            GetPremiumView(closeHandler: {})
                .frame(maxWidth: 480)
//                .frame(width: 400, height: 1000, alignment: .center)
//                .previewLayout(.sizeThatFits)
//                .padding()
//            GetPremiumView(closeHandler: {})
//                .preferredColorScheme(.dark)
//                .frame(width: 800, height: 1200, alignment: .center)
//                .previewLayout(.sizeThatFits)
//                .padding()
        }
    }
}
