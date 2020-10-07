//  Created by Gagandeep Singh on 30/9/20.

import SwiftUI

struct AppConstants {
    static let maxFreeCountdowns: Int = 3
}

final class PreferenceToggle: ObservableObject {
    static let shared = PreferenceToggle()

    var showPreferences: Bool = false
    var showGetPremium: Bool = false

    func open(showGetPremium: Bool) {
        showPreferences = true
        self.showGetPremium = showGetPremium
        objectWillChange.send()
    }

    func closeGetPremium() {
        showGetPremium = false
        objectWillChange.send()
    }

    func close() {
        showPreferences = false
        showGetPremium = false
        objectWillChange.send()
    }
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

    @ObservedObject var countdownSelection = CountdownSelection.shared
    @ObservedObject var purchaseManager = PurchaseManager.shared
    @ObservedObject var preferenceTogle = PreferenceToggle.shared
    @State private var deleteAlertPresented: Bool = false
    @State private var showPhotoPicker: Bool = false

    private var canCreateCountdown: Bool {
        purchaseManager.hasPremium || allCountdowns.count < AppConstants.maxFreeCountdowns
    }

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
                            .navigationBarItems(leading: preferencesButton, trailing: createCountdownButton)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                } else {
                    NavigationView {
                        content
                            .navigationBarItems(leading: preferencesButton, trailing: createCountdownButton)
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
                            .onOpenURL { url in
                                if url.pathComponents.first == "countdown", let uuid = UUID(uuidString: url.lastPathComponent) {
                                    select(countdown: uuid)
                                }
                            }
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .fullScreenCover(isPresented: $showPhotoPicker) {
                PhotoPicker(selectionHandler: didSelectImage)
            }

            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .opacity(preferenceTogle.showPreferences || countdownSelection.isActive ? 1 : 0)

            ForEach(allCountdowns) { countdown in
                let presenting = countdown.id == countdownSelection.id
                let isNew = presenting && countdownSelection.isNew
                CardView(
                    countdown: countdown,
                    isNew: isNew,
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
                    .zIndex(countdownSelection.id == countdown.id ? 1 : 0)
                    .accessibilityElement(children: .contain)
                    .accessibility(sortPriority: presenting ? 1 : 0)
                    .accessibility(hidden: !presenting)
                    .frame(maxWidth: 720, maxHeight: presenting ? .infinity : 0, alignment: .center)
            }

//            if !purchaseManager.hasPremium {
//                GetPremiumView(isPresenting: $showGetPremium)
//                    .accessibility(hidden: !showGetPremium)
//                    .opacity(showGetPremium ? 1 : 0)
//            }

            VStack {
                SettingsView(closeHandler: {
                    withAnimation(.closeCard) {
                        preferenceTogle.close()
                    }
                })
                .frame(minWidth: 360, idealWidth: 400, maxWidth: 480, maxHeight: .infinity)
                .offset(x: preferenceTogle.showPreferences ? 0 : -480)
            }
            .edgesIgnoringSafeArea(.all)
            .opacity(preferenceTogle.showPreferences ? 1 : 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }

    var preferencesButton: some View {
        Button(action: {
            withAnimation(.openCard) {
                preferenceTogle.open(showGetPremium: false)
            }
        }) {
            Image(systemName: "text.justify")
                .font(Font.dank(size: 24))
        }
    }

    var createCountdownButton: some View {
        Button(action: {
            if canCreateCountdown {
                showPhotoPicker = true
            } else {
                withAnimation(.openCard) {
                    preferenceTogle.open(showGetPremium: true)
                }
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .font(Font.dank(size: 24))
        }
    }

    var content: some View {
        ScrollView {
            if !upcoming.isEmpty {
                makeGrid(countdowns: upcoming, label: "Upcoming")
            }

            if !past.isEmpty {
                makeGrid(countdowns: past, label: "Past")
            }
        }
    }

    func select(countdown id: Countdown.ID) {
        withAnimation(.openCard) {
            countdownSelection.select(id, isNew: false)
        }
    }

    func deselectIngredient() {
        withAnimation(.closeCard) {
            countdownSelection.deselect()
        }
    }

    private func pickImage() {
        showPhotoPicker = true
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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 360, maximum: 520))], spacing: 16) {
                ForEach(countdowns) { countdown in
                    let presenting = countdown.id == countdownSelection.id
                    makeCardGriditem(countdown, presenting)
                }
            }
        }
        .padding(.horizontal)
    }

    private func makeCardGriditem(_ countdown: Countdown, _ presenting: Bool) -> some View {
        Button(action: { select(countdown: countdown.id) }) {
            CardFrontView(countdown: countdown, style: .thumbnail, flipHandler: {})
                .matchedGeometryEffect(
                    id: countdown.id,
                    in: namespace,
                    isSource: !presenting
                )
                .cornerRadius(16)
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
        .aspectRatio(verticalSizeClass == .compact ? 2 : 1, contentMode: .fit)
        .accessibility(label: Text(countdown.title))
        .accessibility(hidden: !presenting)
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

