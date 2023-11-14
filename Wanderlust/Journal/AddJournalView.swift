//
//  AddJournalView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/8/23.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct AddJournalView: View {
    @ObservedObject var viewModel: JournalViewModel
    @ObservedObject var locationManager = LocationManager()
    
    let selectedTrip: Trip?
    @Environment(\.dismiss) var dismiss
    
    @State private var journalEntryText: String = ""
    @State private var journalImage: UIImage?
    @State private var journalEntryDate = Date()
    @State private var photoLongitude: Double = 0.0
    @State private var photoLatitude: Double = 0.0
    
    @State private var journalEntryPhoto: String?
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var journalPhotoImage: Image?
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Journal Information")) {
                        HStack {
                            CustomText(text: "Journal Name", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Journal Name", text: $journalEntryText)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Journal Date", textSize: 20, textColor: .black)
                            Spacer()
                            CustomDatePicker(selectedDate: $journalEntryDate)
                        }
                        
                        HStack {
                            CustomText(text: "Journal Picture", textSize: 20, textColor: .black)
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
                                        journalPhotoImage = Image(uiImage: uiImage)
                                        // Save image to file manager and get the URL
                                        if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "JournalPicture", fileName: "\(UUID().uuidString).jpg") {
                                            journalEntryPhoto = imageURL
                                        }
                                        return
                                    }
                                }
                                print("Failed")
                            }
                        }
                        
                        VStack {
                            if let journalPhotoImage {
                                journalPhotoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                
                                HStack {
                                    CustomText(text: "Longitude", textSize: 20, textColor: .black)
                                    Spacer()
                                    CustomText(text: String(locationManager.userLocation?.coordinate.longitude ?? photoLatitude), textSize: 20, textColor: .black)
                                }
                                
                                HStack {
                                    CustomText(text: "Latitude", textSize: 20, textColor: .black)
                                    Spacer()
                                    CustomText(text: String(locationManager.userLocation?.coordinate.latitude ?? photoLongitude), textSize: 20, textColor: .black)
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle("Add Trip")
                .toolbar {
                    ToolbarItem {
                        Button("Save", action: {
                            SaveAndValidateJornal()
                        })
                    }
                }.alert(isPresented: $showAlert) {
                    alert!
                }
        } .onAppear(perform: {
            //On Appear
        })
    }

    func SaveAndValidateJornal() {
        guard Validation.isValidName(journalEntryText) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Journal Name")
            return
        }
        
        guard let selectedTrip = selectedTrip else {
            print("Could not fetch")
            return
        }
        
        guard selectedTrip.tripStartDate!...selectedTrip.tripEndDate! ~= journalEntryDate else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Date must be between \(selectedTrip.tripStartDate!) and \(selectedTrip.tripEndDate!)")
            return
        }
        
        guard let journalEntryPhoto = journalEntryPhoto else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select a cover photo")
            return
        }
        
        guard let photoLatitude = locationManager.userLocation?.coordinate.latitude,
              let photoLongitude = locationManager.userLocation?.coordinate.longitude else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Unable to fetch location")
            return
        }
        
        // Save Journal Details
        dataManagerInstance.saveJournal(
            tripName: selectedTrip,
            journalEntryText: journalEntryText,
            journalEntryDate: journalEntryDate,
            journalEntryPhoto: journalEntryPhoto,
            photoLatitude: photoLatitude,
            photoLongitude: photoLongitude
        )
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Dismiss the sheet after saving the trip
        dismiss()
        
        // Update the trips in the ViewModel
        viewModel.fetchJournals()
    }
}

#Preview {
    AddJournalView(viewModel: JournalViewModel(), selectedTrip: Trip())
}
