//  Created by Gagandeep Singh on 2/10/20.

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.45, dampingFraction: 0.9)
    static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
    static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
    static let togglePreferences = Animation.easeOut(duration: 0.3)
}
