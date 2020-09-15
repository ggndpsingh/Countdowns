//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

final class CreateCountdownViewModel: ObservableObject {
    @Published var countdown: Countdown
    var allDay: Bool {
        didSet {
            allDay
                ? countdown.date.setTimeToZero()
                : countdown.date.setTimeToNow()
        }
    }

    init(id: UUID) {
        let countdown = Countdown(objectID: id) ?? .init()
        self.countdown = countdown
        self.allDay = countdown.date.isMidnight
    }

    internal init(countdown: Countdown) {
        self.countdown = countdown
        allDay = countdown.date.isMidnight
    }

    func save() {
        let context: NSManagedObjectContext = .mainContext
//        DispatchQueue.global(qos: .userInteractive).async {
            do {
                if let existing = CountdownObject.fetch(with: countdown.id, in: context) {
                    existing.update(from: countdown)
                } else {
                    CountdownObject.create(from: countdown, in: context)
                }

                try context.save()
            } catch {
                print(error)
            }
//        }
    }
}

struct CreateCountdownView: View {
    @ObservedObject private var viewModel: CreateCountdownViewModel
    let doneHandler: () -> Void

    init(viewModel: CreateCountdownViewModel, doneHandler: @escaping () -> Void) {
        self.viewModel = viewModel
        self.doneHandler = doneHandler
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                TextField("Title", text: $viewModel.countdown.title)
                    .autocapitalization(.sentences)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading) {
                DatePicker(
                    "",
                    selection: $viewModel.countdown.date, in: .now...,
                    displayedComponents: viewModel.allDay ? .date : [.date, .hourAndMinute])
                    .labelsHidden()
                    .font(.title)
            }
            .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60, alignment: .leading)

            HStack {
                Text("All Day")
                Toggle(isOn: $viewModel.allDay) {
                    Text("All Day")
                        .font(.callout)
                }.labelsHidden()
            }

            Spacer()

            HStack {
                Button(action: {
                    doneHandler()
                }) {
                    Text("Cancel")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(
                        Capsule()
                            .fill(Color.gray))
                }

                Button(action: {
                    viewModel.save()
                    doneHandler()
                }) {
                    Text("Done")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(
                        Capsule()
                            .fill(Color.blue))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

struct CreateCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            let date =  Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero()
            CreateCountdownView(viewModel: .init(countdown: .init(date: date, title: "Test", image: "sweden")), doneHandler: {})
        }
        .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
        .background(Color.red)
        .cornerRadius(24)
    }
}
