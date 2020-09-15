//  Created by Gagandeep Singh on 6/9/20.


import SwiftUI
import CoreData
import UserNotifications

struct CardsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .default)
    private var objects: FetchedResults<CountdownObject>

    @ObservedObject var viewModel: CardsListViewModel
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 480, maximum: 600))]

    private var countdowns: [Countdown] {
        objects.map(Countdown.init).sorted {
            if viewModel.isTemporaryItem(id: $0.id) {
                return true
            }

            return $0.date < $1.date
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(countdowns) {
                        CardView(
                            countdown: $0,
                            isNew: viewModel.isTemporaryItem(id: $0.id),
                            doneHandler: viewModel.handleDone,
                            cancelHandler: viewModel.handleCancel,
                            deleteHandler: viewModel.deleteItem)
                                .environment(\.managedObjectContext, viewContext)
                                .cornerRadius(24)
                    }
                }
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
        withAnimation(.spring()) {
            viewModel.addItem()
        }
    }

    private func deleteItem(id: UUID) {
        withAnimation {
            do {
                if let item = CountdownObject.fetch(with: id, in: viewContext) {
                    viewContext.delete(item)
                }
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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
    }
}
