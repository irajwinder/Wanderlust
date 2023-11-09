//
//  TripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

struct TripView: View {
    @State private var isAddTripView = false
    
   // @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.tripName, ascending: true)],
        animation: .default)
    private var trips: FetchedResults<Trip>

    var body: some View {
        NavigationView {
            List {
                ForEach(trips, id: \.self) { trip in
                    NavigationLink(destination: JournalView(selectedTrip: trip)) {
                        Text(trip.tripName ?? "")
                    }
                }.onDelete { indexSet in
                    for index in indexSet {
                        let trip = trips[index]
                        DataManager.sharedInstance.deleteEntity(trip)
                    }
                }
            }.navigationTitle("Trips")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isAddTripView = true
                        }) {
                            Label("Save", systemImage: "plus")
                        }
                    }
                }
        
        }.sheet(isPresented: $isAddTripView) {
            AddTripView()
        }
       
    }
}


#Preview {
   TripView()
}
