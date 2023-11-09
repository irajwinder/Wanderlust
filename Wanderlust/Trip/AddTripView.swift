//
//  AddTripView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI
import PhotosUI

struct AddTripView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var tripName: String = ""
    @State private var tripCoverPhoto: UIImage?
    @State private var tripStartDate = Date()
    @State private var tripEndDate = Date()
    @State private var tripLongitude: Double = 0.0
    @State private var tripLatitude: Double = 0.0
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var coverPhoto: Image?
    
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
                                        coverPhoto = Image(uiImage: uiImage)
                                        saveImageToFileManager(uiImage)
                                        return
                                    }
                                }
                                print("Failed")
                            }
                        }
                        
                        VStack {
                            if let coverPhoto {
                                coverPhoto
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
                            validateTrip()
                        })
                    }
                }.alert(isPresented: $showAlert) {
                    alert!
                }
        }
        
    }
    
    func validateTrip() {
        guard Validation.isValidName(tripName) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip Name")
            return
        }
        
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
        
        guard Validation.isValidLongitude(tripLongitude) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip Longitude")
            return
        }
        
        guard Validation.isValidLatitude(tripLatitude) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Trip Latitude")
            return
        }
        
        // Save Trip Details
        dataManagerInstance.saveTrip(
            tripName: tripName,
            tripStartDate: tripStartDate,
            tripEndDate: tripEndDate,
            tripCoverPhoto: Data(),
            tripLongitude: tripLongitude,
            tripLatitude: tripLatitude
        )
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Dismiss the sheet after saving the trip
        dismiss()
    }
    
    func saveImageToFileManager(_ uiImage: UIImage) {
        if let imageData = uiImage.jpegData(compressionQuality: 0.5) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let dateString = formatter.string(from: Date())
            let fileName = "profileImage_\(dateString).jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            do {
                try imageData.write(to: fileURL)
                print("Image saved at: \(fileURL)")
            } catch {
                print("Error saving image:", error.localizedDescription)
            }
        }
    }
}

#Preview {
    AddTripView()
}
