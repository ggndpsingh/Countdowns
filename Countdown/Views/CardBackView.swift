//  Created by Gagandeep Singh on 15/9/20.

import SwiftUI

struct CardBackView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel: CardBackViewModel
    @State private var datePickerPresented: Bool = false

    let doneHandler: (Countdown) -> Void
    let deleteHandler: () -> Void

    init(
        viewModel: CardBackViewModel,
        doneHandler: @escaping (Countdown) -> Void,
        deleteHandler: @escaping () -> Void) {
        self.viewModel = viewModel
        self.doneHandler = doneHandler
        self.deleteHandler = deleteHandler
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                CardBackground(imageURL: viewModel.countdown.image, size: geometry.size)
                    .overlay(Rectangle().fill(Color.systemBackground.opacity(0.6)))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                VStack(alignment: .leading, spacing:24) {
                    ButtonsView(
                        hasChanges: viewModel.hasChanges,
                        hasReminder: viewModel.hasReminder,
                        reminderHandler: { viewModel.hasReminder.toggle() },
                        deleteHandler: deleteHandler,
                        doneHandler: {
                            doneHandler(viewModel.countdown)
                        })

                    VStack(spacing: 16) {
                        TitleInput(title: $viewModel.title)
                        DateInput(
                            date: $viewModel.date,
                            allDay: $viewModel.allDay)
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .animation(.easeIn)
        .cornerRadius(24)
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                CardBackView(viewModel: .init(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1565700430899-1c56a5cf64e3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"), countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), doneHandler: {_ in }, deleteHandler: {})
            }
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)

            ZStack {
                CardBackView(viewModel: .init(countdown: .init(date: Date().addingTimeInterval(3600 * 3600).bySettingTimeToZero(), title: "Test", image: "https://images.unsplash.com/photo-1565700430899-1c56a5cf64e3?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2NjI1MX0"), countdownsManager: .init(context: PersistenceController.inMemory.container.viewContext)), doneHandler: {_ in }, deleteHandler: {})
            }
            .preferredColorScheme(.dark)
            .frame(maxWidth: .infinity, minHeight: 320, idealHeight: 320, maxHeight: 320)
            .cornerRadius(24)
        }
        .padding()
    }
}

extension CardBackView {
    struct ButtonsView: View {
        @State private var deleteAlertPresented: Bool = false
        let hasChanges: Bool
        let hasReminder: Bool
        let reminderHandler: () -> Void
        let deleteHandler: () -> Void
        let doneHandler: () -> Void

        var body: some View {
            HStack(spacing: 16) {
                RoundButton(
                    action: doneHandler,
                    image: hasChanges ? "checkmark" : "plus",
                    color: hasChanges ? .green : .gray)
                    .rotationEffect(.degrees(hasChanges ? 0 : 45))

                Spacer()

                RoundButton(
                    action: reminderHandler,
                    image: hasReminder ? "bell.fill" : "bell",
                    color: hasReminder ? .orange : .gray)

                RoundButton(
                    action: { deleteAlertPresented = true },
                    image: "trash",
                    color: .red)
                }
                .alert(isPresented: $deleteAlertPresented) {
                    Alert(
                        title: Text("Delete Countdown"),
                        message: Text("Are you sure you want to delete this countdown?"),
                        primaryButton: .destructive(Text("Delete"), action: deleteHandler),
                        secondaryButton: .cancel(Text("Cancel")))
            }
        }
    }
}

extension CardBackView.ButtonsView {
    struct RoundButton: View {
        let action: () -> Void
        let image: String
        let color: Color

        var body: some View {
            Button(action: action) {
                Image(systemName: image)
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .background(Blur(style: .systemThinMaterial))
                    .clipShape(Circle())
                    .foregroundColor(color)
            }
        }
    }
}

extension CardBackView {
    struct TitleInput: View {
        @Binding var title: String

        var body: some View {
            TextField("New Countdown", text: $title)
                .font(Font.system(size: 20, weight: .regular, design: .default))
                .autocapitalization(.words)
                .padding()
                .foregroundColor(Color.label)
                .background(Color.systemBackground.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: .infinity)
        }
    }
}

extension CardBackView {
    struct DateInput: View {
        @Binding var date: Date
        @Binding var allDay: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                DatePicker(
                    "",
                    selection: $date,
                    in: .now...)
                    .labelsHidden()

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
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.systemBackground.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
