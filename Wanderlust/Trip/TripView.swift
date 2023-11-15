//
//  TripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

class TripsViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    func fetchTrips() {
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
       
        guard let fetch = user.trip as? Set<Trip> else {
            print("Could not fetch trips for the user")
            return
        }
        self.trips = Array(fetch)
   }
}

struct TripView: View {
    @StateObject private var viewModel = TripsViewModel()
    @State private var isAddTripView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips, id: \.self) { trip in
                    NavigationLink(destination: JournalView(selectedTrip: trip)) {
                        CustomCoverPhoto(coverPhoto: fileManagerClassInstance.loadImageFromFileManager(relativePath: trip.tripCoverPhoto ?? ""))
                        VStack(alignment: .leading) {
                            Text(trip.tripName ?? "")
                                .font(.headline)
                            Text("\(Validation.dateToString(trip.tripStartDate)) to \(Validation.dateToString(trip.tripEndDate))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete { indexSet in
                    for index in indexSet {
                        let trip = viewModel.trips[index]
                        DataManager.sharedInstance.deleteEntity(trip)
                        
                    }
                    viewModel.fetchTrips()
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
           // AddTripView()
           AddTripView(viewModel: viewModel)
        }
        .onAppear(perform: {
            viewModel.fetchTrips()
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            print(paths[0])
        })
    }
}


#Preview {
   TripView()
}
