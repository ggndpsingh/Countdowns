//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

final class PhotoSourceSelection: ObservableObject {
    var source: PhotoSource? {
        willSet {
            switch newValue {
            case .some(let value):
                switch value {
                case .unsplash:
                    showUnsplashPicker = true
                case .library:
                    showLibraryPicker = true
                }
                objectWillChange.send()
            case .none:
                break
            }
        }
    }

    var showUnsplashPicker: Bool = false
    var showLibraryPicker: Bool = false
}

final class CountdownSelection: ObservableObject {
    @Published var id: Countdown.ID?
    var isNew: Bool = false

    var isActive: Bool { id != nil }

    func select(_ id: Countdown.ID, isNew: Bool) {
        self.id = id
        self.isNew = isNew
    }

    func deselect() {
        id = nil
        isNew = false
    }
}

struct CardsListView: View {
    @Environment(\.countdownsManager) private var countdownsManager
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @FetchRequest<CountdownObject>(
        entity: CountdownObject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .spring()
    ) var fetchedObjects

    @ObservedObject var countdownSelection = CountdownSelection()
    @ObservedObject var photoSourceSelection = PhotoSourceSelection()
    @State private var deleteAlertPresented: Bool = false
    @Namespace private var namespace

    private var countdowns: [Countdown] {
        let countdowns = fetchedObjects.map(Countdown.init)
        return countdowns.sorted {
            $0.date < $1.date
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if countdowns.isEmpty {
                    EmptyListView()
                } else {
                    container
                }
            }
            .alert(isPresented: $deleteAlertPresented) {
                Alert(
                    title: Text("Delete Countdown"),
                    message: Text("Are you sure you want to delete this countdown?"),
                    primaryButton: .destructive(Text("Delete")) {
                        guard let id = countdownSelection.id else { return }
                        withAnimation(.closeCard) {
                            countdownsManager.deleteObject(with: id)
                            deselectIngredient()
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")))
            }
            .fullScreenCover(isPresented: $photoSourceSelection.showUnsplashPicker) {
                UnsplashPicker(selectionHandler: didSelectImage)
            }
            .toolbar {
                PhotoSourceMenu(
                    label: {
                        Image(systemName: "plus.circle.fill")
                            .font(Font.dank(size: 24))
                    }, action: pickImage)
                    .disabled(countdownSelection.isActive)
                    .foregroundColor(countdownSelection.isActive ? .secondaryLabel : .brand)
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $photoSourceSelection.showLibraryPicker) {
            LibraryPicker(selectionHandler: didSelectImage)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var container: some View {
        ZStack {
            ScrollView {
                content
            }
            .accessibility(hidden: countdownSelection.isActive)

            Blur(style: .systemMaterial)
                .edgesIgnoringSafeArea(.all)
                .opacity(countdownSelection.isActive ? 1 : 0)

            ForEach(countdowns) { countdown in
                let presenting = countdown.id == countdownSelection.id
                let isNew = presenting && countdownSelection.isNew
                VStack {
                    CardView(
                        countdown: countdown,
                        isNew: isNew,
                        visibleSide: isNew ? .back : .front,
                        imageHandler: pickImage,
                        doneHandler: { updatedCountdown in
                            if
                                let id = countdownSelection.id,
                                countdownSelection.isNew &&
                                !countdownsManager.canSaveObject(for: updatedCountdown)
                            {
                                countdownsManager.deleteObject(with: id)
                                countdownSelection.deselect()
                                return
                            }

                            countdownSelection.isNew = false
                            countdownsManager.updateObject(for: updatedCountdown)
                        },
                        closeHandler: deselectIngredient,
                        deleteHandler: {
                            deleteAlertPresented = true
                        })
                        .matchedGeometryEffect(id: countdown.id, in: namespace, isSource: presenting)
                        .aspectRatio(verticalSizeClass == .compact ? 2 : 0.75, contentMode: .fit)
                        .shadow(color: Color.black.opacity(presenting ? 0.2 : 0), radius: 20, y: 10)
                        .padding(20)
                        .opacity(presenting ? 1 : 0)
                        .accessibilityElement(children: .contain)
                        .accessibility(sortPriority: presenting ? 1 : 0)
                        .accessibility(hidden: !presenting)
                }
                .frame(maxWidth: 720, maxHeight: presenting ? .infinity : 0, alignment: .center)
            }
        }
    }

    var content: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 420, maximum: 520))], spacing: 16) {
                    ForEach(countdowns) { countdown in
                        let presenting = countdown.id == countdownSelection.id
                        Button(action: { select(countdown: countdown) }) {
                            CardFrontView(countdown: countdown, style: .thumbnail, flipHandler: {})
                                .matchedGeometryEffect(
                                    id: countdown.id,
                                    in: namespace,
                                    isSource: !presenting
                                )
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                        .aspectRatio(verticalSizeClass == .compact ? 2 : 1.5, contentMode: .fit)
                        .accessibility(label: Text(countdown.title))
                        .accessibility(hidden: !presenting)
                    }
                }
            }
            .padding()
        }
    }

    func select(countdown: Countdown) {
        withAnimation(.openCard) {
            countdownSelection.select(countdown.id, isNew: false)
        }
    }

    func deselectIngredient() {
        withAnimation(.closeCard) {
            countdownSelection.deselect()
        }
    }

    private func pickImage(from source: PhotoSource) {
        photoSourceSelection.source = source
    }

    func didSelectImage(_ image: UIImage?) {
        guard let image = image else { return }
        if let id = countdownSelection.id {
            countdownsManager.updateImage(image, for: id)
            return
        }

        if let newID = countdownsManager.createNewObject(with: image) {
            countdownSelection.select(newID, isNew: true)
        }
    }
}

struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        CardsListView()
            .environment(\.countdownsManager, CountdownsManager(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

