//
//  AddTripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI
import PhotosUI

struct AddTripView: View {
    @ObservedObject var viewModel: TripsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tripName: String = ""
    @State private var tripCoverPhoto: UIImage?
    @State private var tripStartDate = Date()
    @State private var tripEndDate = Date()
    @State private var coverPhoto: String?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var coverPhotoImage: Image?
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
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
                            CustomText(text: "Cover Picture", textSize: 20, textColor: .black)
                            Spacer()
                            
                            PhotosPicker(
                                "Select photo",
                                selection: $selectedPickerImage,
                                matching: .images
                            )
                            
                        }.onChange(of: selectedPickerImage) {
                            Task {
                                if let data = try? await selectedPickerImage?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        coverPhotoImage = Image(uiImage: uiImage)
                                        // Save image to file manager and get the URL
                                        if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "CoverPicture", fileName: "\(UUID().uuidString).jpg") {
                                            coverPhoto = imageURL
                                        }
                                        return
                                    }
                                }
                                print("Failed")
                            }
                        }
                        
                        VStack {
                            if let coverPhotoImage {
                                coverPhotoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Add Trip")
                .toolbar {
                    ToolbarItem {
                        Button("Save", action: {
                            SaveAndValidateTrip()
                        })
                    }
                }.alert(isPresented: $showAlert) {
                    alert!
                }
        }        
    }
    
    func SaveAndValidateTrip() {
        guard Validation.isValidName(tripName) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip Name")
            return
        }
        
        guard Validation.isValidTripStartDate(tripStartDate) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip Start date")
            return
        }
        
        guard Validation.isValidTripEndDate(tripEndDate, startDate: tripStartDate) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip End date")
            return
        }
        
        guard let coverPhoto = coverPhoto else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select a cover photo")
            return
        }
        
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
        
        // Save Trip Details
        dataManagerInstance.saveTrip(
            user: user,
            tripName: tripName,
            tripStartDate: tripStartDate,
            tripEndDate: tripEndDate,
            tripCoverPhoto: coverPhoto
        )
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Dismiss the sheet after saving the trip
        dismiss()
        // Update the trips in the ViewModel
        viewModel.fetchTrips()
    }
    
   
}

#Preview {
    AddTripView(viewModel: TripsViewModel())
}
