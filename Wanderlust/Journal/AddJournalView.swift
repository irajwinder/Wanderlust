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
    let selectedTrip: Trip?
    @Environment(\.dismiss) var dismiss
    
    @State private var journalText: String = ""
    @State private var journalImage: UIImage?
    @State private var photoTimeStamp = Date()
    @State private var photoLongitude: Double = 0.0
    @State private var photoLatitude: Double = 0.0
    @State private var photoTag: String = ""
    @State private var photoCaption: String = ""
    
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var journalPhoto: Image?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Journal Information")) {
                        HStack {
                            CustomText(text: "Journal Name", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Journal Name", text: $journalText)
                                .padding()
                        }

                        HStack {
                            CustomText(text: "Photo Caption", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Photo Caption", text: $photoCaption)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Photo Tag", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Photo Tag", text: $photoTag)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Longitude", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Longitude", text: .constant(String(photoLongitude)))
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Latitude", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Latitude", text: .constant(String(photoLatitude)))
                                .padding()
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
                                        journalPhoto = Image(uiImage: uiImage)
                                        saveImageToFileManager(uiImage)
                                        return
                                    }
                                }
                                print("Failed")
                            }
                        }
                        
                        VStack {
                            if let journalPhoto {
                                journalPhoto
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
                            validateJournal()
                        })
                    }
                }.alert(isPresented: $showAlert) {
                    alert!
                }
        } .onAppear(perform: {
            //On Appear
        })
        
    }
    
    func validateJournal() {
        guard Validation.isValidName(journalText) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Journal Name")
            return
        }
        
        guard Validation.isValidName(photoCaption) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Caption")
            return
        }
        
        guard Validation.isValidName(photoTag) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Tag")
            return
        }
        
        guard Validation.isValidLongitude(photoLongitude) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Photo Longitude")
            return
        }
        
        guard Validation.isValidLatitude(photoLatitude) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Photo Latitude")
            return
        }
        
        guard let selectedTrip = selectedTrip else {
            print("Could not fetch")
            return
        }
        
        // Save Journal Details
        dataManagerInstance.saveJournal(
            tripName: selectedTrip,
            journalText: journalText,
            journalPhoto: Data(),
            photoLatitude: photoLatitude,
            photoLongitude: photoLongitude,
            photoCaption: photoCaption,
            photoTag: photoTag,
            photoTimeStamp: photoTimeStamp
//            tripName: selectedTrip,
//            journalText: journalText,
//            journalPhoto: Data(),
//            journalLocation: journalLocation,
//            journalTimeStamp: journalTimeStamp,
//            tripLongitude: tripLongitude,
//            tripLatitude: tripLatitude
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
    AddJournalView(selectedTrip: Trip())
}
