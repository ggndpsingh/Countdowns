//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI

struct CreateCountdownView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var allDay: Bool = false
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Countdown title", text: $title)
                        .autocapitalization(.sentences)
                }

                Section(header: Text("Date")) {
                    Toggle(isOn: $allDay) {
                        Text("All Day")
                    }.onReceive([allDay].publisher.first()) { isOn in
                        date = isOn ? date.bySettingTimeToZero() : date.bySettingTimeToNow()
                    }

                    Text(date.displayString)
                        .font(.callout)

                    DatePicker(
                        "",
                        selection: $date, in: Date()...Date.distantFuture,
                        displayedComponents: allDay ? .date : [.date, .hourAndMinute])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: 400)
                }
            }
            .navigationTitle("New Countdown")
            .navigationBarItems(
                trailing: Button("Create") {
                    DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            try CountdownItem.create(in: viewContext, title: title, date: date, image: nil)
                        } catch {
                            print(error)
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct CreateCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCountdownView()
    }
}

extension Date {
    func bySettingTimeToZero() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components) ?? self
    }

    func bySettingTimeToNow() -> Date {
        let now = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = now.hour
        components.minute = now.minute
        components.second = now.second
        return Calendar.current.date(from: components) ?? self
    }
}
