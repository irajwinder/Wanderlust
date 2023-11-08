//
//  AddTripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

struct AddTripView: View {
    @State private var tripName: String = ""
    @State private var tripCoverPhoto: UIImage?
    @State private var tripStartDate = Date()
    @State private var tripEndDate = Date()
    @State private var tripLongitude: Double = 0.0
    @State private var tripLatitude: Double = 0.0
    
    @State private var showAlert = false
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Trip Information")) {
                        HStack {
                            CustomText(text: "Trip Name", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Trip Name", text: $tripName)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Start date", textSize: 20, textColor: .black)
                            CustomDatePicker(selectedDate: $tripStartDate)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "End Date", textSize: 20, textColor: .black)
                            CustomDatePicker(selectedDate: $tripEndDate)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Longitude", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Longitude", text: .constant(String(tripLongitude)))
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Latitude", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Latitude", text: .constant(String(tripLatitude)))
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Cover Photo", textSize: 20, textColor: .black)
                        }
                    }
                }
            }.navigationBarTitle("Add Trip")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
//                            if Validation.isValidName(tripName) || tripStartDate > tripEndDate || Validation.isValidLongitude(tripLongitude) || Validation.isValidLatitude(tripLatitude) {
//                                showAlert = true
//                            } else {
                            
                            //Save image to document directory and then save path in coredata(URL/ path)
                                if let imageData = tripCoverPhoto?.jpegData(compressionQuality: 0.5) {
                                    dataManagerInstance.saveTrip(
                                        tripName: tripName,
                                        tripStartDate: tripStartDate,
                                        tripEndDate: tripEndDate,
                                        tripCoverPhoto: imageData,
                                        tripLongitude: tripLongitude,
                                        tripLatitude: tripLatitude
                                    )
                                } else {
                                    // Handle the case where the conversion fails
                                    print("Failed to convert the cover photo to Data.")
                                }
//                            }
                        }) {
                            Label("Save", systemImage: "plus")
                        }
                    }
                }
        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text("Please fill in all the fields."), dismissButton: .default(Text("OK")))
//        }
    }
}

#Preview {
    AddTripView()
}
