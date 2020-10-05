//  Created by Gagandeep Singh on 3/10/20.

import SwiftUI

struct CreateCountdownButton: View {
    let countdownsCount: Int
    let createCountdownHandler: () -> Void
    let getPremiumHandler: () -> Void

    private var canCreateCountdown: Bool {
        countdownsCount < AppConstants.maxFreeCountdowns ||
        PurchaseManager.shared.hasPremium
    }

    var body: some View {
        HStack {
            if canCreateCountdown {
                Button(action: createCountdownHandler) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create a countdown")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.brand)
                    .clipShape(Capsule())
                    .padding([.top], 16)
                }
                .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                
            } else {
                Button(action: getPremiumHandler) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Get Premium")
                    }
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.primary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding([.top], 16)
                }
                .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    enum Action {
        case createCountdown
        case getPremium
    }
}
