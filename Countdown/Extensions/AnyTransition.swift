//  Created by Gagandeep Singh on 8/10/20.

import SwiftUI

extension AnyTransition {
    static var moveAndFadeLeading: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    static var moveAndFadeBottom: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    static var moveAndFadeTop: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    static var moveAndFadeVertical: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
//            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .top)
//            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
