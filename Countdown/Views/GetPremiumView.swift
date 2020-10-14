//  Created by Gagandeep Singh on 2/10/20.

import SwiftUI
import StoreKit

struct GetPremiumView: View {
    @Environment(\.colorScheme) private var colorScheme
    let product: SKProduct?
    let closeHandler: () -> Void
    @State var isLoading = false

    private var price: String? {
        guard let product = product else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = product.priceLocale
        formatter.numberStyle = .currency
        return formatter.string(from: product.price)
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

                        faq.padding(.bottom, 120)
                    }
                    .padding(.horizontal, 24)
                    .padding([.top], 40)
                }
            }
        }
        .transition(.premium)
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
        .font(.system(size: 15, weight: .light, design: .default))
        .lineSpacing(4)
    }

    private var featuresList: some View {
        let features: [String] = [
            "Unlimited events", "Add any event to a Widget", "No watermark"
        ]

        return VStack(alignment: .leading, spacing: 12) {
            Text("What you get with Premium?")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .padding([.bottom], 4)

            ForEach(features, id: \.self) { feature in
                HStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                    Text(feature)
                        .font(.system(size: 14, weight: .light, design: .default))
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
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                        Text(answer)
                            .font(.system(size: 14, weight: .light, design: .default))
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
                    .font(.system(size: 14, weight: .medium, design: .default))
            })
        }
    }

    private func restorePurchase() {
        PurchaseManager.shared.restorePurchases()
    }
}
