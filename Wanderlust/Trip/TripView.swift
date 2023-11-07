//
//  TripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI


struct TripView: View {
    @FetchRequest(sortDescriptors: []) var trips: FetchedResults<Trip>
    
    var body: some View {
        VStack {
            List(trips) { trip in
                Text(trip.tripName!)
            }
        }
    }
}

#Preview {
   TripView()
}
