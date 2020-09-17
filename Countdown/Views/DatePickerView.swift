//  Created by Gagandeep Singh on 17/9/20.

import SwiftUI

struct DatePickerView: View {
    @State var date: Date = .now
    @State private var allDay: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "",
                    selection: $date, in: .now...)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
        }
    }
}
