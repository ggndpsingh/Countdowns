//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @ObservedObject private var viewModel: CardBackViewModel
    let doneHandler: (Countdown) -> Void
    let cancelHandler: (UUID) -> Void

    init(
        viewModel: CardBackViewModel,
        doneHandler: @escaping (Countdown) -> Void,
        cancelHandler: @escaping (UUID) -> Void) {
        self.viewModel = viewModel
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(imageURL: viewModel.countdown.image, blur: true, size: geometry.size)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("New Countdown", text: $viewModel.countdown.title)
                            .font(.title2)
                            .autocapitalization(.words)
                        Text(viewModel.countdown.dateString)
                            .font(.caption)
                            .foregroundColor(.gray)
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
                        Toggle(isOn: $viewModel.reminder) {
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

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardBackView(viewModel: .init(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "apple")), doneHandler: {_ in}, cancelHandler: {_ in})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()
    }
}
