//  Created by Gagandeep Singh on 25/9/20.

import SwiftUI

extension Font {
    static func dank(size: CGFloat) -> Font {
        Font(UIFont(name: "DankMono-Regular", size: size) ?? .systemFont(ofSize: size))
    }
}
