//
//  CreateCountdownView.swift
//  Countdown
//
//  Created by Gagandeep Singh on 6/9/20.
//

import SwiftUI

struct CreateCountdownView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Countdown title", text: $title)
                        .autocapitalization(.sentences)
                }

                Section(header: Text("Date")) {
                    Text(date.displayString)
                        .font(.callout)

                    DatePicker("", selection: $date, in: Date()...Date.distantFuture)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: 400)
                }
            }
            .navigationTitle("New Countdown")
            .navigationBarItems(
                trailing: Button("Create") {
                    DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            try CountdownItem.create(in: viewContext, title: title, date: date)
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
