//  Created by Gagandeep Singh on 2/10/20.

import UIKit

extension UIImage {
    convenience init?(sample: Sample) {
        self.init(named: sample.rawValue)
    }

    static var samples: [UIImage] {
        Sample.allCases.compactMap { UIImage(sample: $0) }
    }

    static var randomSample:  UIImage? { samples.randomElement() }

    enum Sample: String, CaseIterable {
        case dolomites
        case holi
    }
}
