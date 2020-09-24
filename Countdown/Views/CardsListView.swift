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
    @Environment(\.countdownsManager) private var countdownsManager

    @StateObject var listPositionModel: ListPositionModel = .init()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .default
    ) private var objects: FetchedResults<CountdownObject>

    @ObservedObject var viewModel: CardsListViewModel
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 480, maximum: 600))]
    @State var pickingPhotos: Bool = false

    private var countdowns: [Countdown] {
        return objects.map(Countdown.init).sorted {

            if viewModel.isTemporaryItem(id: $0.id) {
                return true
            }

            return $0.date < $1.date
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(countdowns) { countdown in
                            CardView(
                                countdown: countdown,
                                isFlipped: viewModel.isCardFlipped(id: countdown.id),
                                isNew: viewModel.isTemporaryItem(id: countdown.id),
                                tapHandler: { id in
                                    withFlipAnimation(viewModel.flipCard(id: id))
                                },
                                doneHandler: { updatedCountdown in
                                    withFlipAnimation(viewModel.handleDone(countdown: updatedCountdown))
                                },
                                deleteHandler: {
                                    withFlipAnimation(viewModel.deleteItem(id: countdown.id))
                                })
                                .id(countdown.id)
                        }
                    }
                    .onReceive(listPositionModel.$position) { position in
                        withAnimation {
                            switch position {
                            case .top:
                                proxy.scrollTo(countdowns.first?.id, anchor: .top)
                            case .bottom:
                                proxy.scrollTo(countdowns.last?.id, anchor: .bottom)
                            default:
                                break
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $pickingPhotos) {
                PhotoPicker(selectionHandler: viewModel.addItem)
            }
            .toolbar {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                .disabled(viewModel.hasTemporaryItem)
            }
            .navigationTitle("Countdowns")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func addItem() {
        listPositionModel.position = .top
        pickingPhotos = true
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
    }
}
