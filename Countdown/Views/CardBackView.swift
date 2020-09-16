//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var deleteAlertPresented: Bool = false
    let doneHandler: (Countdown) -> Void
    let cancelHandler: (UUID) -> Void
    let deleteHandler: (UUID) -> Void

    init(
        viewModel: CardBackViewModel,
        doneHandler: @escaping (Countdown) -> Void,
        cancelHandler: @escaping (UUID) -> Void,
        deleteHandler: @escaping (UUID) -> Void) {
        self.viewModel = viewModel
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(imageURL: viewModel.countdown.image, blur: true, size: geometry.size)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("New Countdown", text: $viewModel.countdown.title)
                            .font(Font.system(size: 20, weight: .regular, design: .default))
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

                    Divider()

                    Group {
                        HStack {
                            Toggle(isOn: $viewModel.allDay) {
                                Image(systemName: "moon.fill")
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(Color.white.opacity(0.7)))
                                    .foregroundColor(.black)
                                    .font(.caption)
                                Text("Set time to midnight")
                                    .font(Font.system(size: 16, weight: .regular, design: .default))
                            }
                        }.padding(.vertical, 8)

                        Divider()

                        HStack {
                            Toggle(isOn: $viewModel.reminder) {
                                Image(systemName: "bell.fill")
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(Color.white.opacity(0.7)))
                                    .foregroundColor(.black)
                                    .font(.caption)
                                Text("Add a reminder")
                                    .font(Font.system(size: 16, weight: .regular, design: .default))
                            }
                        }.padding(.vertical, 8)
                    }

                    Divider()

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

                        Button(action: { deleteAlertPresented = true }, label: {
                            Image(systemName: "trash")
                                .frame(width: 44, height: 44)
                                .background(Blur(style: .systemThinMaterial))
                                .clipShape(Circle())
                                .foregroundColor(.red)
                        })
                    }
                    .font(.headline)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .alert(isPresented: $deleteAlertPresented) {
            Alert(
                title: Text("Delete Countdown"),
                message: Text("Are you sure you want to delete this countdown?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteHandler(viewModel.countdown.id)
                }, secondaryButton: .cancel(Text("Cancel")))
        }
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardBackView(viewModel: .init(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "apple")), doneHandler: {_ in}, cancelHandler: {_ in}, deleteHandler: {_ in})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()
    }
}
