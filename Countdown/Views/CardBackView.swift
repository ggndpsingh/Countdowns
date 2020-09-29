//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var datePickerPresented: Bool = false

    let imageHandler: (PhotoSource) -> Void
    let doneHandler: (Countdown, Bool) -> Void
    let deleteHandler: () -> Void

    init(
        viewModel: CardBackViewModel,
        imageHandler: @escaping (PhotoSource) -> Void,
        doneHandler: @escaping (Countdown, Bool) -> Void,
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
                ButtonsView(
                    isNew: viewModel.isNew,
                    hasEnded: viewModel.countdown.hasEnded,
                    canSave: viewModel.canSave,
                    hasReminder: viewModel.hasReminder,
                    reminderHandler: { viewModel.hasReminder.toggle() },
                    deleteHandler: deleteHandler,
                    imageHandler: imageHandler,
                    doneHandler: {
                        doneHandler(viewModel.countdown, viewModel.canSave)
                    })

                VStack(spacing: 8) {
                    TitleInput(
                        title: $viewModel.title,
                        disabled: !viewModel.isNew && viewModel.countdown.hasEnded)
                    DateInput(
                        date: $viewModel.date,
                        allDay: $viewModel.allDay,
                        disabled: !viewModel.isNew && viewModel.countdown.hasEnded)
                }

                Spacer()
            }
            .padding()
        }
        .animation(.easeIn)
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
                                RoundButton.ButtonImage("photo.fill", color: Color.Pastel.blue)
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

        struct RoundButton: View {
            let action: () -> Void
            let image: String
            let color: Color

            var body: some View {
                Button(action: action) {
                    ButtonImage(image, color: color)
                }
            }

            struct ButtonImage: View {
                private let image: String
                private let color: Color

                init(_ image: String, color: Color) {
                    self.image = image
                    self.color = color
                }

                var body: some View {
                    Image(systemName: image)
                        .font(Font.system(size: 14, weight: .medium, design: .monospaced))
                        .frame(width: 40, height: 40)
                        .background(Blur(style: .systemThickMaterial))
                        .clipShape(Circle())
                        .foregroundColor(color)
                }
            }
        }
    }
}

extension CardBackView {
    struct TitleInput: View {
        private let minLength = 3
        private let maxLength = 24
        @Binding var title: String
        let disabled: Bool

        private var remainingLimit: Int { maxLength - title.count }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                TextField("New Countdown", text: $title)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                    .padding(.vertical, 12)
                    .disabled(disabled)

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
            .foregroundColor(disabled ? .secondaryLabel : .label)
            .background(Blur(style: disabled ? .systemThinMaterial : .systemThickMaterial))
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
        let disabled: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 8) {
                    DatePicker(
                        "",
                        selection: $date,
                        in: .now...)
                        .disabled(disabled)
                        .labelsHidden()

                    if !disabled && date <= Date() {
                        Text("set a future date")
                            .font(Font.dank(size: 11))
                            .foregroundColor(.red)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                Toggle(isOn: $allDay) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .frame(width: 24, height: 24)
                        Text("All day event")
                    }
                    .foregroundColor(disabled ? .secondaryLabel : .label)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                }
                .disabled(disabled)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Blur(style: disabled ? .systemThinMaterial : .systemThickMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#if DEBUG
struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView(viewModel: .init(countdown: .preview, isNew: true, countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), imageHandler: {_ in }, doneHandler: {_,_  in }, deleteHandler: {})
            .frame(width: 400, height: 320)
            .previewLayout(.sizeThatFits)

        CardBackView(viewModel: .init(countdown: .preview, isNew: false, countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), imageHandler: {_ in }, doneHandler: {_,_  in }, deleteHandler: {})
            .frame(width: 400, height: 320)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
#endif
