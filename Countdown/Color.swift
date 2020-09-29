//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let separator = Color(UIColor.separator)
}

extension Color {
    enum Pastel {
        static let purple = Color(UIColor(hex: 0x5D3E56))
        static let hotPink = Color(UIColor(hex: 0xFFAEBC))
        static let blue = Color(UIColor(hex: 0x32afa9))
        static let red = Color(UIColor(hex: 0xF65156))
        static let yellow = Color(UIColor(hex: 0xFFF4BD))
    }

    static let pastels: [Color] = [
        Pastel.hotPink,
        Pastel.purple,
        Pastel.blue,
        Pastel.red,
        Pastel.yellow
    ]
}

private extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }

    convenience init(hex: Int) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff)
    }
}
