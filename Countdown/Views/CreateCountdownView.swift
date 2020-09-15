//  Created by Gagandeep Singh on 6/9/20.

import SwiftUI
import CoreData

final class CreateCountdownViewModel: ObservableObject {
    @Published var countdown: Countdown
    var allDay: Bool {
        set {
            newValue
                ? countdown.date.setTimeToZero()
                : countdown.date.setTimeToNow()
        }
        get { return countdown.date.isMidnight }
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
}

struct CreateCountdownView: View {
    @ObservedObject private var viewModel: CreateCountdownViewModel
    let doneHandler: (Countdown) -> Void
    let cancelHandler: (UUID) -> Void

    init(
        viewModel: CreateCountdownViewModel,
        doneHandler: @escaping (Countdown) -> Void,
        cancelHandler: @escaping (UUID) -> Void) {
        self.viewModel = viewModel
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(image: viewModel.countdown.image, size: geometry.size)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                Blur(style: .systemThinMaterial)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 16) {
                        TextField("Title", text: $viewModel.countdown.title)
                            .autocapitalization(.sentences)
                    }
                    .padding()
                    .background(Color.systemBackground.opacity(0.7))
                    .foregroundColor(Color.primary)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)

                    HStack {
                        DatePicker(
                            "",
                            selection: $viewModel.countdown.date, in: .now...)
                            .labelsHidden()
                            .font(.title)
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))

                    HStack {
                        Toggle(isOn: $viewModel.allDay) {
                            Image(systemName: "moon.fill")
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color.white.opacity(0.7)))
                                .foregroundColor(.black)
                                .font(.caption)
                            Text("Set time to midnight")
                                .font(.subheadline)
                        }
                    }.padding(.vertical, 8)

                    HStack {
                        Toggle(isOn: $viewModel.allDay) {
                            Image(systemName: "bell.fill")
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color.white.opacity(0.7)))
                                .foregroundColor(.black)
                                .font(.caption)
                            Text("Add a reminder")
                                .font(.subheadline)
                        }
                    }.padding(.vertical, 8)

                    Spacer()

                    HStack {
                        Button(action: { cancelHandler(viewModel.countdown.id) }) {
                            Text("Cancel")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: 44)
                                .background(
                                    Capsule()
                                        .fill(Color.gray))
                        }

                        Button(action: { doneHandler(viewModel.countdown) }) {
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
            }
        }
    }
}

struct CreateCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                let date =  Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero()
                CreateCountdownView(viewModel: .init(countdown: .init(date: date, title: "Test", image: "sweden")), doneHandler: {_ in }, cancelHandler: {_ in })
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .background(Color.red)
            .cornerRadius(24)

            ZStack {
                let date =  Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero()
                CreateCountdownView(viewModel: .init(countdown: .init(date: date, title: "Test", image: "sweden")), doneHandler: {_ in }, cancelHandler: {_ in })
            }
            .preferredColorScheme(.dark)
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .background(Color.red)
            .cornerRadius(24)
        }
    }
}
