//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var datePickerPresented: Bool = false

    let imageHandler: (PhotoSource) -> Void
    let doneHandler: (Countdown) -> Void
    let deleteHandler: () -> Void

    init(
        viewModel: CardBackViewModel,
        imageHandler: @escaping (PhotoSource) -> Void,
        doneHandler: @escaping (Countdown) -> Void,
        deleteHandler: @escaping () -> Void) {
        self.viewModel = viewModel
        self.imageHandler = imageHandler
        self.doneHandler = doneHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        ZStack {
            CardBackground(image: viewModel.countdown.image)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

            VStack(alignment: .leading, spacing:24) {
                VStack(spacing: 8) {
                    TitleInput(
                        title: $viewModel.title)
                    DateInput(
                        date: $viewModel.date,
                        allDay: $viewModel.allDay)
                }

                Spacer()

                ButtonsView(
                    isNew: viewModel.isNew,
                    hasEnded: viewModel.countdown.hasEnded,
                    canSave: viewModel.canSave,
                    hasReminder: viewModel.hasReminder,
                    reminderHandler: { viewModel.hasReminder.toggle() },
                    deleteHandler: deleteHandler,
                    imageHandler: imageHandler,
                    doneHandler: {
                        doneHandler(viewModel.countdown)
                    })

            }
            .padding()
        }
        .cornerRadius(16)
    }
}

extension CardBackView {
    struct ButtonsView: View {
        let isNew: Bool
        let hasEnded: Bool
        let canSave: Bool
        let hasReminder: Bool
        let reminderHandler: () -> Void
        let deleteHandler: () -> Void
        let imageHandler: (PhotoSource) -> Void
        let doneHandler: () -> Void

        var body: some View {
            HStack(spacing: 16) {
                if !isNew {
                    RoundButton(
                        action: deleteHandler,
                        image: "trash",
                        color: .red)

                    if !hasEnded {
                        PhotoSourceMenu(
                            label: {
                                RoundButton.ButtonImage("photo.fill", color: .brand)
                            },
                            action: imageHandler)
                    }
                }

                Spacer()

                RoundButton(
                    action: doneHandler,
                    image: canSave ? "checkmark" : isNew ? "xmark" : "arrow.backward",
                    color: canSave ? .green : .secondaryLabel)
            }
        }
    }
}

extension CardBackView {
    struct TitleInput: View {
        private let minLength = 3
        private let maxLength = 24
        @Binding var title: String

        private var remainingLimit: Int { maxLength - title.count }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                TextField("New Countdown", text: $title)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                    .padding(.vertical, 12)

                HStack(spacing: 0) {
                    Spacer()
                    Text("\(title.count)")
                        .foregroundColor((title.count < 3 || remainingLimit <= 5) ? .red : .secondaryLabel)
                    Text(" / \(minLength)-\(maxLength)")
                        .foregroundColor(.secondaryLabel)
                }
                .padding([.bottom], 8)
                .font(Font.dank(size: 11))
            }
            .padding(.horizontal, 8)
            .foregroundColor(.label)
            .background(Blur(style: .systemThickMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity)
            .onChange(of: title, perform: { value in
                self.title = String(value.prefix(maxLength))
            })
        }
    }
}

extension CardBackView {
    struct DateInput: View {
        @Binding var date: Date
        @Binding var allDay: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 8) {
                    DatePicker(
                        "",
                        selection: $date,
                        in: .now...)
                        .labelsHidden()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                Toggle(isOn: $allDay) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .frame(width: 24, height: 24)
                        Text("All day event")
                    }
                    .foregroundColor(.label)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                }
                .toggleStyle(SwitchToggleStyle(tint: .brand))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Blur(style: .systemThickMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#if DEBUG
struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CardBackView(viewModel: .init(countdown: .preview, isNew: false, countdownsManager: .init(context: PersistenceController.preview.container.viewContext)), imageHandler: {_ in }, doneHandler: {_ in }, deleteHandler: {})
        }
        .padding()
    }
}
#endif
