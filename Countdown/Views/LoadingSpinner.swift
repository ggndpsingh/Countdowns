//  Created by Gagandeep Singh on 3/10/20.

import SwiftUI

struct BuyPremiumButton: View {
    let action: () -> Void
    let state: ButtonState

    private var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var body: some View {
        Button(action: {}) {
            Text(state.text)
                .foregroundColor(.systemBackground)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .frame(height: 48, alignment: .center)
                .background(Color.primary)
                .cornerRadius(8)
        }
        .buttonStyle(SquishableButtonStyle())
    }

    enum ButtonState {
        case idle(String)
        case loading

        var text: String {
            switch self {
            case .idle(let price):
                return price
            default:
                return ""
            }
        }
    }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BuyPremiumButton(action: {}, state: .idle("$1.49"))
                .frame(width: 400, height: 60, alignment: .center)
                .previewLayout(.sizeThatFits)
            BuyPremiumButton(action: {}, state: .idle("$1.49"))
                .frame(width: 400, height: 60, alignment: .center)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
