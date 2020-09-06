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

    @State private var isCreating: Bool = false

    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 400, maximum: 600))]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(countdowns) { countdown in
                        CountdownView(countdown: countdown, tapHandler: deleteItem)
                    }
                }
                .padding()
            }
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

    private func deleteItem(item: CountdownItem) {
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
    }
}
