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
    @State private var tripCoverPicture: UIImage?
    @State private var isAddTripView = false
    
    
    @StateObject private var viewModel = TripsViewModel()
    
   // @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.tripName, ascending: true)],
//        animation: .default)
//    private var trips: FetchedResults<Trip>

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips, id: \.self) { trip in
//                    ForEach(trips.filter { $0.user?.userEmail == loggedInUserID }, id: \.self) { trip in
                    NavigationLink(destination: JournalView(selectedTrip: trip)) {
                        CustomCoverPhoto(coverPhoto: tripCoverPicture)
                        VStack(alignment: .leading) {
                            Text(trip.tripName ?? "")
                                .font(.headline)
                            Text("\(dateToString(trip.tripStartDate)) to \(dateToString(trip.tripEndDate))")
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
    
    func dateToString(_ date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if let startDate = date {
            return dateFormatter.string(from: startDate)
        } else {
            return "N/A"
        }
    }
}


#Preview {
   TripView()
}
