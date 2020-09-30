////  Created by Gagandeep Singh on 6/9/20.
//
//
//import SwiftUI
//import CoreData
//import UserNotifications
//
//func withFlipAnimation<Result>(_ body: @autoclosure () throws -> Result) rethrows -> Result {
//    try withAnimation(.spring(response: 0.6, dampingFraction: 0.9), body)
//}
//
//struct CardsListView: View {
//    @FetchRequest<CountdownObject>(
//        entity: CountdownObject.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \CountdownObject.date, ascending: true)],
//        animation: .spring()
//    ) var fetchedObjects
//
//    @Environment(\.managedObjectContext) private var viewContext
//    @ObservedObject var viewModel: CardsListViewModel
//    @State private var pickingImage: Bool = false
//    @State private var photoSource: PhotoSource?
//    @State private var deleteAlertPresented: Bool = false
//
//    var countdowns: [Countdown] {
//        let countdowns = fetchedObjects.map(Countdown.init)
//        return countdowns.sorted {
//            if $0.hasEnded {
//                return viewModel.isTemporaryItem(id: $0.id)
//            }
//
//            return $0.date < $1.date
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            Group {
//                if countdowns.isEmpty {
//                    EmptyListView()
//                } else {
//                    ScrollView {
//                        ScrollViewReader { proxy in
//                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 480, maximum: 600))], spacing: 16) {
//                                ForEach(countdowns) { countdown in
//                                    CardView(
//                                        countdown: countdown,
//                                        isFlipped: viewModel.isCardFlipped(id: countdown.id),
//                                        isNew: viewModel.isTemporaryItem(id: countdown.id),
//                                        imageHandler: {
//                                            photoSource = $0
//                                        },
//                                        doneHandler: { updatedCountdown, shouldSave  in
//                                            withFlipAnimation(viewModel.handleDone(countdown: updatedCountdown, shouldSave: shouldSave))
//                                        },
//                                        deleteHandler: {
//                                            deleteAlertPresented = true
//                                        })
//                                        .id(countdown.id)
//                                }
//                            }
//                            .onReceive(viewModel.$scrollToItem) { item in
//                                withAnimation(.easeOut) { proxy.scrollTo(item) }
//                            }
//                        }
//                    }
//                }
//            }
//            .onChange(of: photoSource, perform: { value in
//                pickingImage = value != nil
//            })
//            .alert(isPresented: $deleteAlertPresented) {
//                Alert(
//                    title: Text("Delete Countdown"),
//                    message: Text("Are you sure you want to delete this countdown?"),
//                    primaryButton: .destructive(Text("Delete")) {
////                        viewModel.deleteItem()
//                    },
//                    secondaryButton: .cancel(Text("Cancel")))
//            }
//            .fullScreenCover(isPresented: $pickingImage) {
//                PhotoPicker(source: photoSource!) { image in
//                    photoSource = nil
//                    viewModel.didSelectImage(image)
//                }
//            }
//            .toolbar {
//                PhotoSourceMenu(label: { Image(systemName: "plus.circle.fill") }, action: addItem)
//                    .disabled(viewModel.hasTemporaryItem)
//            }
//            .foregroundColor(.brand)
//            .navigationTitle("Upcoming")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//
//    private func addItem(photoSource: PhotoSource) {
//        withFlipAnimation(
//            viewModel.flippedCardID = nil
//        )
//        viewModel.scrollToItem = countdowns.first?.id
//        self.photoSource = photoSource
//    }
//}
