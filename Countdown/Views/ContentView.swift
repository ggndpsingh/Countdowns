//  Created by Gagandeep Singh on 6/9/20.


import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .default)
    private var objects: FetchedResults<CountdownObject>

    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 400, maximum: 600))]
    @State private var isCreating: Bool = false
    @State private var flipped: [UUID] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(objects) {
                        let countdown = Countdown(object: $0)
                        CountdownGridItem(countdown: countdown, flipped: flipped.contains(countdown.id))
                            .environment(\.managedObjectContext, viewContext)
                            .cornerRadius(24)
                    }
                }
            }
            .toolbar {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Countdowns")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func addItem() {
        objects.forEach { deleteItem(id: $0.id!) }
        
        let item = Countdown()
        CountdownObject.create(from: item, in: viewContext)
        flipped.append(item.id)
        do {
            try viewContext.save()
        } catch {
            print(error)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.inMemory.container.viewContext)
    }
}
