//  Created by Gagandeep Singh on 3/10/20.

import SwiftUI

final class PhotoSourceSelection: ObservableObject {
    var source: PhotoSource? {
        willSet {
            switch newValue {
            case .some(let value):
                switch value {
                case .unsplash:
                    showUnsplashPicker = true
                case .library:
                    showLibraryPicker = true
                }
                objectWillChange.send()
            case .none:
                break
            }
        }
    }

    var showUnsplashPicker: Bool = false
    var showLibraryPicker: Bool = false
}
