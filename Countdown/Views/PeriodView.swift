//  Created by Gagandeep Singh on 3/10/20.

import SwiftUI

struct PeriodView: View {
    var body: some View {
        List(1..<20) { i in
            let date = Date().addingTimeInterval(TimeInterval(i * 3600 * 36))
            VStack(alignment: .leading) {
                Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium))
                Text(Date().periodUntil(date).description)
            }
        }
    }
}



struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView()
    }
}
