//
//  TripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

struct TripView: View {
    @State private var tripCoverPicture: UIImage?
    @State private var isAddTripView = false
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    @State var trips: [Trip] = []
    
   // @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.tripName, ascending: true)],
//        animation: .default)
//    private var trips: FetchedResults<Trip>

    var body: some View {
        NavigationView {
            List {
                ForEach(trips, id: \.self) { trip in
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
        .onAppear(perform: {
            fetchTrips()
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
    
     func fetchTrips() {
         guard let loggedInUserID = loggedInUserID else {
             print("Could not unwrap")
             return
         }
         guard let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
             print("Could not fetch")
             return
         }
        
         guard let fetch = user.trip as? Set<Trip> else {
             print("Could not fetch trips for the user")
             return
         }
        
        self.trips = Array(fetch)
    }
}


#Preview {
   TripView()
}
