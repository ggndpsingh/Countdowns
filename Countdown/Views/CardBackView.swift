//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var datePickerPresented: Bool = false

    let imageHandler: () -> Void
    let doneHandler: (Countdown) -> Void
    let deleteHandler: () -> Void

    init(
        viewModel: CardBackViewModel,
        imageHandler: @escaping () -> Void,
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
                Group {
                    if verticalSizeClass == .compact {
                        HStack(alignment: .top, spacing: 24) {
                            TitleInput(title: $viewModel.title)
                            DateInput(
                                date: $viewModel.countdown.date,
                                allDay: $viewModel.allDay)
                        }
                    } else {
                        VStack(spacing: 24) {
                            TitleInput(title: $viewModel.title)
                            DateInput(
                                date: $viewModel.countdown.date,
                                allDay: $viewModel.allDay)
                        }
                    }
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
            .padding([.top], 16)
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
        let imageHandler: () -> Void
        let doneHandler: () -> Void

        var body: some View {
            HStack(spacing: 16) {
                if !isNew {
                    RoundButton(
                        action: deleteHandler,
                        image: "trash",
                        color: .red)

                    RoundButton(
                        action: imageHandler,
                        image: "photo.fill",
                        color: .brand)
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
        @Environment(\.colorScheme) private var scheme
        private let minLength = 3
        private let maxLength = 24
        @Binding var title: String

        @State var date: Date = Date()

        private var remainingLimit: Int { maxLength - title.count }

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    Text("What's happening?")
                        .font(Font.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(title.count)")
                        .foregroundColor((title.count < 3 || remainingLimit <= 5) ? .red : .secondaryLabel)
                        .font(Font.dank(size: 11))

                    Text(" / \(minLength)-\(maxLength)")
                        .font(Font.dank(size: 11))
                }

                TextField("New Countdown", text: $title)
                    .font(Font.system(size: 18, weight: .regular, design: .default))
                    .padding(8)
                    .background(
                        Color.systemBackground
                            .colorInvert()
                            .opacity(scheme == .dark ? 0.2 : 0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(16)
            .foregroundColor(.label)
            .background(Blur(style: .systemMaterial))
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
        @Binding var allDay: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("When is it happening?")
                        .font(Font.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)

                    DatePicker("", selection: $date, in: .now...)
                        .labelsHidden()
                        .modifier(GrayscaleDatePickerStyle())
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Is it an all day event?")
                        .font(Font.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)

                    Picker(selection: $allDay, label: Text("What is your favorite color?")) {
                        Text("Yes").tag(1)
                        Text("No").tag(0)
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Blur(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct GrayscaleDatePickerStyle: ViewModifier {
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        Group {
            if scheme == .dark {
                content
                    .colorMultiply(.black)
                    .colorInvert()
            } else {
                content
                    .colorMultiply(.black)
            }
        }
    }
}

#if DEBUG
struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardBackView(viewModel: .init(countdown: .preview, isNew: false, countdownsManager: .init(context: PersistenceController.preview.container.viewContext)), imageHandler: {}, doneHandler: {_ in }, deleteHandler: {})
                .frame(width: 400, height: 420, alignment: .center)
                .previewLayout(.sizeThatFits)

            CardBackView(viewModel: .init(countdown: .preview, isNew: false, countdownsManager: .init(context: PersistenceController.preview.container.viewContext)), imageHandler: {}, doneHandler: {_ in }, deleteHandler: {})
                .preferredColorScheme(.dark)
                .frame(width: 400, height: 420, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
        .padding()
    }
}
#endif
