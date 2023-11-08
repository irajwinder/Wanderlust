//
//  ContentView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.tripName, ascending: true)],
//        animation: .default)
//    private var trips: FetchedResults<Trip>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(trips) { trip in
//                    NavigationLink {
//                        Text(trip.tripName ?? "")
//                    } label: {
//                        Text("Hello")
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Trip", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select a Trip")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newTrip = Trip(context: viewContext)
//            newTrip.tripName = "Hello"
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { trips[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
