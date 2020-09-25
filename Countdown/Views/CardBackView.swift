//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var datePickerPresented: Bool = false

    let imageHandler: () -> Void
    let doneHandler: (Countdown, Bool) -> Void
    let deleteHandler: () -> Void

    init(
        viewModel: CardBackViewModel,
        imageHandler: @escaping () -> Void,
        doneHandler: @escaping (Countdown, Bool) -> Void,
        deleteHandler: @escaping () -> Void) {
        self.viewModel = viewModel
        self.imageHandler = imageHandler
        self.doneHandler = doneHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        ZStack {
            CardBackground(imageURL: viewModel.countdown.image)
                .overlay(Rectangle().fill(Color.systemBackground.opacity(0.6)))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

            VStack(alignment: .leading, spacing:24) {
                ButtonsView(
                    isNew: viewModel.isNew,
                    canSave: viewModel.canSave,
                    hasReminder: viewModel.hasReminder,
                    reminderHandler: { viewModel.hasReminder.toggle() },
                    deleteHandler: deleteHandler,
                    imageHandler: imageHandler,
                    doneHandler: {
                        doneHandler(viewModel.countdown, viewModel.canSave)
                    })

                VStack(spacing: 8) {
                    TitleInput(title: $viewModel.title)
                    DateInput(
                        date: $viewModel.date,
                        allDay: $viewModel.allDay)
                }

                Spacer()
            }
            .padding()
        }
        .animation(.easeIn)
        .cornerRadius(24)
    }
}

extension CardBackView {
    struct ButtonsView: View {
        @State private var deleteAlertPresented: Bool = false
        let isNew: Bool
        let canSave: Bool
        let hasReminder: Bool
        let reminderHandler: () -> Void
        let deleteHandler: () -> Void
        let imageHandler: () -> Void
        let doneHandler: () -> Void

        var body: some View {
            HStack(spacing: 16) {
                if !isNew {
                    RoundButton(
                        action: { deleteAlertPresented = true },
                        image: "trash",
                        color: .red)

                    RoundButton(
                        action: imageHandler,
                        image: "photo.fill",
                        color: Color.Pastel.blue)
                }

                Spacer()

                RoundButton(
                    action: reminderHandler,
                    image: hasReminder ? "bell.fill" : "bell",
                    color: hasReminder ? .orange : .secondaryLabel)

                RoundButton(
                    action: doneHandler,
                    image: canSave ? "checkmark" : isNew ? "trash" : "arrow.backward",
                    color: canSave ? .green : isNew ? .red : .secondaryLabel)
                }
                .alert(isPresented: $deleteAlertPresented) {
                    Alert(
                        title: Text("Delete Countdown"),
                        message: Text("Are you sure you want to delete this countdown?"),
                        primaryButton: .destructive(Text("Delete"), action: deleteHandler),
                        secondaryButton: .cancel(Text("Cancel")))
            }
        }

        struct RoundButton: View {
            let action: () -> Void
            let image: String
            let color: Color

            var body: some View {
                Button(action: action) {
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

        private var remainingLimit: Int { maxLength - title.count }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                TextField("New Countdown", text: $title)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                    .autocapitalization(.words)
                    .padding(.vertical, 12)

                HStack(spacing: 0) {
                    Spacer()
                    Text("\(title.count)")
                        .foregroundColor((title.count < 3 || remainingLimit <= 5) ? .red : .secondaryLabel)
                    Text(" / \(minLength)-\(maxLength)")
                        .foregroundColor(.secondaryLabel)
                }
                .padding([.bottom], 8)
                .font(Font.system(size: 11, weight: .medium, design: .monospaced))
            }
            .padding(.horizontal, 8)
            .foregroundColor(Color.label)
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

                    if date <= Date() {
                        Text("Must be in future")
                            .font(Font.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(.secondaryLabel)
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
                    .foregroundColor(.label)
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                }
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
        CardBackView(viewModel: .init(countdown: .preview, isNew: true, countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), imageHandler: {}, doneHandler: {_,_  in }, deleteHandler: {})
            .frame(width: 400, height: 320)
            .previewLayout(.sizeThatFits)

        CardBackView(viewModel: .init(countdown: .preview, isNew: false, countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), imageHandler: {}, doneHandler: {_,_  in }, deleteHandler: {})
            .frame(width: 400, height: 320)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
#endif
