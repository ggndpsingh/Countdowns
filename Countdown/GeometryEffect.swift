//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.55, dampingFraction: 0.9)
    static let closeCard = Animation.spring(response: 0.45, dampingFraction: 1)
    static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}

struct SomeView: View {
    @Environment(\.countdownsManager) private var countdownsManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @FetchRequest<CountdownObject>(
        entity: CountdownObject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .spring()
    ) var fetchedObjects

    @State private var pickingImageFromLibrary: Bool = false
    @State private var pickingImageFromUnsplash: Bool = false
    @State private var deleteAlertPresented: Bool = false
    @State private var new: Countdown.ID?
    @State private var selected: Countdown.ID?
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
                        guard let id = selected else { return }
                        withAnimation(.closeCard) {
                            selected = nil
                            countdownsManager.deleteObject(with: id)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")))
            }
            .fullScreenCover(isPresented: $pickingImageFromUnsplash) {
                UnsplashPicker(selectionHandler: didSelectImage)
            }
            .toolbar {
                PhotoSourceMenu(label: { Image(systemName: "plus.circle.fill") }, action: pickImage)
                    .disabled(selected != nil)
                    .foregroundColor(selected == nil ? .brand : .secondaryLabel)
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $pickingImageFromLibrary) {
            LibraryPicker(selectionHandler: didSelectImage)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var container: some View {
        ZStack {
            ScrollView {
                content
            }
            .accessibility(hidden: selected != nil)

            Blur(style: .systemMaterial)
                .edgesIgnoringSafeArea(.all)
                .opacity(selected != nil ? 1 : 0)

            ForEach(countdowns) { countdown in
                let presenting = selected == countdown.id
                VStack {
                    CardView(
                        countdown: countdown,
                        visibleSide: countdown.id == new ? .back : .front,
                        imageHandler: pickImage,
                        doneHandler: { updatedCountdown in
                            if new != nil, updatedCountdown.id == new {
                                new = nil
                                if !countdownsManager.objectHasChange(countdown: updatedCountdown) {
                                    countdownsManager.deleteObject(with: updatedCountdown.id)
                                    selected = nil
                                    return
                                }
                            }

                            countdownsManager.updateObject(for: updatedCountdown)
                        },
                        closeHandler: deselectIngredient,
                        deleteHandler: {
                            deleteAlertPresented = true
                        })
                        .matchedGeometryEffect(id: countdown.id, in: namespace, isSource: presenting)
                        .aspectRatio(0.75, contentMode: .fit)
                        .shadow(color: Color.black.opacity(presenting ? 0.2 : 0), radius: 20, y: 10)
                        .padding(20)
                        .opacity(presenting ? 1 : 0)
                        .accessibilityElement(children: .contain)
                        .accessibility(sortPriority: presenting ? 1 : 0)
                        .accessibility(hidden: !presenting)
                }
                .frame(maxWidth: 520, alignment: .center)
            }
        }
    }

    var content: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 420, maximum: 520))], spacing: 16) {
                    ForEach(countdowns) { countdown in
                        let presenting = selected == countdown.id
                        Button(action: { select(countdown: countdown) }) {
                            CardFrontView(countdown: countdown, style: .thumbnail, flipHandler: {})
                                .matchedGeometryEffect(
                                    id: countdown.id,
                                    in: namespace,
                                    isSource: !presenting
                                )
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(SquishableButtonStyle())
                        .aspectRatio( 1, contentMode: .fit)
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
            selected = countdown.id
        }
    }

    func deselectIngredient() {
        new = nil
        withAnimation(.closeCard) {
            selected = nil
        }
    }

    private func pickImage(from photoSource: PhotoSource) {
        switch photoSource {
        case .library:
            pickingImageFromLibrary = true
        case .unsplash:
            pickingImageFromUnsplash = true
        }
    }

    func didSelectImage(_ image: UIImage?) {
        guard let image = image else { return }
        if let id = selected {
            countdownsManager.updateImage(image, for: id)
            return
        }

        new = countdownsManager.createNewObject(with: image)
        selected = new
    }
}

struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        SomeView()
            .environment(\.countdownsManager, CountdownsManager(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

