//  Created by Gagandeep Singh on 2/10/20.

import SwiftUI
import StoreKit

struct GetPremiumView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresenting: Bool
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

    private func premiumFeatureItem(text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text(text)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primary.opacity(0.1))
        .cornerRadius(8)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.systemBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .edgesIgnoringSafeArea(.all)

            RoundButton(action: {
                isPresenting = false
            }, image: "xmark", color: .secondaryLabel)
            .padding()

            ZStack {
                VStack(alignment: .center, spacing: 40) {
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

                    Group {
                        Text("You have used up your " + String(AppConstants.maxFreeCountdowns) + " free Countdowns.\n")
                        + Text("Get Countdowns Premium ")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                        + Text("for unlimited Countdowns.")
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .lineSpacing(3)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What you get with Premium?")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .padding([.bottom], 4)

                        premiumFeatureItem(text: "Unlimited Countdowns")
                        premiumFeatureItem(text: "Choose any Countdown in a Widget")
                        premiumFeatureItem(text: "Add Photos from your library")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14, weight: .regular, design: .default))

                    Button(action: {
                        guard let product = product else { return }
                        withAnimation(.easeIn) {
                            isLoading = true
                        }
                        PurchaseManager.shared.buyProduct(product) { success in
                            withAnimation(.easeIn) {
                                isLoading = false
                                if success {
                                    isPresenting = false
                                }
                            }
                        }
                    }) {
                        ZStack {
                            Text(buttonText)
                                .foregroundColor(.systemBackground)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color.primary)
                                .cornerRadius(4)

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
                    .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                }
                .frame(maxWidth: 320)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .cornerRadius(16)
        .onAppear(perform: loadProduct)
    }

    func loadProduct() {
        PurchaseManager.shared.requestProduct { self.product = $0 }
    }
}

struct GetPremiumView_Previews: PreviewProvider {
    @State static var presenting: Bool = true

    static var previews: some View {
        Group {
            GetPremiumView(isPresenting: $presenting)
                .frame(width: 400, height: 600, alignment: .center)
                .previewLayout(.sizeThatFits)
                .padding()
            GetPremiumView(isPresenting: $presenting)
                .preferredColorScheme(.dark)
                .frame(width: 800, height: 1200, alignment: .center)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
