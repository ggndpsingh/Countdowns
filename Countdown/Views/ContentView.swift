//
//  ContentView.swift
//  Countdown
//
//  Created by Gagandeep Singh on 6/9/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownItem.date_, ascending: true)],
        animation: .default)
    private var countdowns: FetchedResults<CountdownItem>

    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 400, maximum: 600))]
    @State private var isCreating: Bool = false
    @State private var timer: Timer?
    @State private var viewStates: [CountdownGridItem.ViewState] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewStates) { viewState in
                        CountdownGridItem(viewState: viewState)
                            .cornerRadius(24)
                            .onTapGesture {
                                deleteItem(id: viewState.id)
                            }
                    }
                }
            }
            .onAppear { startCountdown() }
            .onDisappear { pauseCountdown() }
            .toolbar {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationTitle("Countdowns")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isCreating, content: {
            CreateCountdownView()
                .environment(\.managedObjectContext, viewContext)
        })
    }

    private func addItem() {
        withAnimation {
            isCreating = true
        }
    }

    private func deleteItem(id: NSManagedObjectID) {
        let item = viewContext.object(with: id)
        withAnimation {
            viewContext.delete(item)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            viewStates = countdowns.map(CountdownGridItem.ViewState.init)
        })
        timer?.fire()
    }

    private func pauseCountdown() {
        timer?.invalidate()
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
