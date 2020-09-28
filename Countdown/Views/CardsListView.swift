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

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {

            }
            .toolbar {
                Menu {
                    Button(action: {}) {
                        Text("Camera")
                        Image(systemName: "camera.fill")
                            .foregroundColor(.primary)
                    }
                    Button(action: {}) {
                        Text("Unsplash")
                        Image("unsplashIcon")
                            .foregroundColor(.primary)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
//                .disabled(viewModel.hasTemporaryItem)
            }
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CardsListView: View {
    @FetchRequest<CountdownObject>(
        entity: CountdownObject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
        animation: .spring()
    ) var fetchedObjects
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: CardsListViewModel
    @State private var pickingImage: Bool = false
    @State private var photoSource: PhotoSource?

    var countdowns: [Countdown] {
        return fetchedObjects.map(Countdown.init).sorted {

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
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 480, maximum: 600))], spacing: 16) {
                        ForEach(countdowns) { countdown in
                            CardView(
                                countdown: countdown,
                                isFlipped: viewModel.isCardFlipped(id: countdown.id),
                                isNew: viewModel.isTemporaryItem(id: countdown.id),
                                tapHandler: { id in
                                    withFlipAnimation(viewModel.flipCard(id: id))
                                },
                                imageHandler: {
                                    photoSource = $0
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
                    .onChange(of: photoSource, perform: { value in
                        pickingImage = value != nil
                    })
                    .onReceive(viewModel.$scrollToItem) { item in
                        withAnimation(.easeOut) { proxy.scrollTo(item) }
                    }
                }
            }
            .fullScreenCover(isPresented: $pickingImage) {
                PhotoPicker(source: photoSource!) { image in
                    photoSource = nil
                    viewModel.didSelectImage(image)
                }
            }
            .toolbar {
                PhotoSourceMenu(label: { Image(systemName: "plus.circle.fill") }, action: addItem)
                    .disabled(viewModel.hasTemporaryItem)
            }
            .foregroundColor(.primary)
            .navigationTitle("Upcoming")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func addItem(photoSource: PhotoSource) {
        withFlipAnimation(
            viewModel.flippedCardID = nil
        )
        viewModel.scrollToItem = countdowns.first?.id
        self.photoSource = photoSource
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
        ContentView()
    }
}

struct PhotoSourceMenu<Label: View>: View {
    let label: () -> Label
    let action: (PhotoSource) -> Void

    var body: some View {
        Menu {
            Button(action: { action(.library) }) {
                Text("Photo Library")
                Image(systemName: "photo.on.rectangle")
            }
            Button(action: { action(.unsplash) }) {
                Text("Unsplash")
                Image("unsplashIcon")
                    .frame(width: 16, height: 16, alignment: .center)
            }
        } label: {
            label()
        }
    }
}
