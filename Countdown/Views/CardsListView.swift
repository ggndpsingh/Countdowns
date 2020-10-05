//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

struct AppConstants {
    static let maxFreeCountdowns: Int = 3
}

struct CardsListView: View {
    @FetchRequest<CountdownObject>(
        entity: CountdownObject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .spring()
    ) var fetchedObjects

    @Namespace private var namespace
    @Environment(\.countdownsManager) private var countdownsManager
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @ObservedObject var countdownSelection = CountdownSelection()
    @ObservedObject var photoSourceSelection = PhotoSourceSelection()
    @ObservedObject var purchaseManager = PurchaseManager.shared
    @State private var deleteAlertPresented: Bool = false
    @State private var showGetPremium: Bool = false

    private var upcoming: [Countdown] {
        fetchedObjects.map(Countdown.init)
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
    }

    private var past: [Countdown] {
        fetchedObjects.map(Countdown.init)
            .filter { $0.date <= Date() }
            .sorted { $0.date < $1.date }
    }

    private var allCountdowns: [Countdown] { upcoming + past }

    var body: some View {
        ZStack {
            Group {
                if allCountdowns.isEmpty {
                    NavigationView {
                        EmptyListView()
                            .navigationBarItems(trailing: barButton)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                } else {
                    NavigationView {
                        content
                            .navigationBarItems(trailing: barButton)
                            .navigationTitle("Upcoming")
                            .navigationBarTitleDisplayMode(.inline)

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
                            .fullScreenCover(isPresented: $photoSourceSelection.showLibraryPicker) {
                                LibraryPicker(selectionHandler: didSelectImage)
                            }
                    }
                    .fullScreenCover(isPresented: $showGetPremium, content: {
                        GetPremiumView()
//                            .opacity(showGetPremium ? 1 : 0)
//                            .accessibility(hidden: !showGetPremium)
//                            .scaleEffect(showGetPremium ? 1 : 0.5)
//                            .offset(y: showGetPremium ? 0 : 600)
                    })
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }

            Blur(style: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .opacity(countdownSelection.isActive ? 1 : 0)

            ForEach(allCountdowns) { countdown in
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

    var barButton: some View {
        Group {
            if upcoming.count < 3 || PurchaseManager.shared.hasPremium {
                PhotoSourceMenu(
                    label: {
                        Image(systemName: "plus.circle.fill")
                            .font(Font.dank(size: 24))
                    }, action: pickImage)
                    .disabled(countdownSelection.isActive)
                    .foregroundColor(countdownSelection.isActive ? .secondaryLabel : .brand)
            } else {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        showGetPremium.toggle()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(Font.dank(size: 24))
                }
            }
        }
    }

    var content: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !upcoming.isEmpty {
                    makeGrid(countdowns: upcoming, label: "Upcoming")
                }

                if !past.isEmpty {
                    makeGrid(countdowns: past, label: "Past")
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

    private func makeGrid(countdowns: [Countdown], label: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
                .padding([.top], 16)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 420, maximum: 520))], spacing: 16) {
                ForEach(countdowns) { countdown in
                    let presenting = countdown.id == countdownSelection.id
                    makeCardGriditem(countdown, presenting)
                }
            }
        }
    }

    private func makeCardGriditem(_ countdown: Countdown, _ presenting: Bool) -> some View {
        Button(action: { select(countdown: countdown) }) {
            CardFrontView(countdown: countdown, style: .thumbnail, flipHandler: {})
                .matchedGeometryEffect(
                    id: countdown.id,
                    in: namespace,
                    isSource: !presenting
                )
                .contentShape(Rectangle())
                .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
                .aspectRatio(verticalSizeClass == .compact ? 2 : 1.5, contentMode: .fit)
                .accessibility(label: Text(countdown.title))
                .accessibility(hidden: !presenting)
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
    }
}

struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardsListView()
                .environment(\.countdownsManager, CountdownsManager(context: PersistenceController.preview.container.viewContext))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

            CardsListView()
                .environment(\.countdownsManager, CountdownsManager(context: PersistenceController.preview.container.viewContext))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}

