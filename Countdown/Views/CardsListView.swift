//  Created by Gagandeep Singh on 6/9/20.


import SwiftUI
import CoreData
import UserNotifications

func withFlipAnimation<Result>(_ body: @autoclosure () throws -> Result) rethrows -> Result {
    try withAnimation(.spring(response: 0.7, dampingFraction: 0.9), body)
}

extension Animation {
    static var flipAnimation: Animation {
        .spring(response: 1, dampingFraction: 0.8)
    }
}

class ListPositionModel: ObservableObject {
    enum Position {
        case top, bottom
    }

    @Published var position: Position?
}

struct CardsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: CardsListViewModel
    @State private var pickingImage: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 480, maximum: 600))], spacing: 16) {
                        ForEach(viewModel.countdowns) { countdown in
                            CardView(
                                countdown: countdown,
                                isFlipped: viewModel.isCardFlipped(id: countdown.id),
                                isNew: viewModel.isTemporaryItem(id: countdown.id),
                                tapHandler: { id in
                                    withFlipAnimation(viewModel.flipCard(id: id))
                                },
                                imageHandler: {
                                    pickingImage = true
                                },
                                doneHandler: { updatedCountdown, shouldSave  in
                                    withFlipAnimation(viewModel.handleDone(countdown: updatedCountdown, shouldSave: shouldSave))
                                },
                                deleteHandler: {
                                    withFlipAnimation(viewModel.deleteItem(id: countdown.id))
                                })
                                .id(countdown.id)
                        }
                    }
                    .onReceive(viewModel.$scrollToItem) { item in
                        withAnimation(.easeOut) { proxy.scrollTo(item) }
                    }
                }
            }
            .sheet(isPresented: $pickingImage) {
                PhotoPicker(selectionHandler: viewModel.didSelectImage)
            }
            .toolbar {
                Button(action: addItem) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.primary)
                }
                .disabled(viewModel.hasTemporaryItem)
            }
            .foregroundColor(.white)
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func addItem() {
        withFlipAnimation(
            viewModel.flippedCardID = nil
        )
        viewModel.scrollToItem = viewModel.countdowns.first?.id
        pickingImage = true
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CardsListView_Previews: PreviewProvider {
    static var previews: some View {
        CardsListView(viewModel: .init(context: PersistenceController.inMemory.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.inMemory.container.viewContext)
            .environment(\.countdownsManager, CountdownsManager(context: PersistenceController.inMemory.container.viewContext))
    }
}
