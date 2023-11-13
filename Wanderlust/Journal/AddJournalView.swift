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
    let selectedTrip: Trip?
    @Environment(\.dismiss) var dismiss
    
    @State private var journalText: String = ""
    @State private var journalImage: UIImage?
    @State private var photoTimeStamp = Date()
    @State private var photoLongitude: Double = 0.0
    @State private var photoLatitude: Double = 0.0
    
    @State private var journalPhoto: String?
    
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
                            CustomTextField(placeholder: "Journal Name", text: $journalText)
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
                                        journalPhotoImage = Image(uiImage: uiImage)
                                        // Save image to file manager and get the URL
                                        if let imageURL = saveImageToFileManager(uiImage) {
                                            journalPhoto = imageURL
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
                                    CustomText(text: String(photoLongitude), textSize: 20, textColor: .black)
                                }
                                
                                HStack {
                                    CustomText(text: "Latitude", textSize: 20, textColor: .black)
                                    Spacer()
                                    CustomText(text: String(photoLatitude), textSize: 20, textColor: .black)
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
        guard Validation.isValidName(journalText) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Journal Name")
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
        
        guard let journalPhoto = journalPhoto else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select a cover photo")
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
            journalPhoto: journalPhoto,
            photoLatitude: photoLatitude,
            photoLongitude: photoLongitude,
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
        
        // Update the trips in the ViewModel
        viewModel.fetchJournals()
    }
    
    func saveImageToFileManager(_ uiImage: UIImage) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        let folderName = "JournalPicture"
        let fileName = "\(journalText).jpg"
        let relativeURL  = "\(folderName)/\(fileName)"

        do {
            // Get the documents directory URL
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(relativeURL)

            // Create the necessary directory structure if it doesn't exist
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Write the image data to the file at the specified URL
            try imageData.write(to: fileURL)
            print("Image Location: \(fileURL)")
            return relativeURL
            
        } catch {
            // Print an error message if any issues occur during the image-saving process
            print("Error saving image:", error.localizedDescription)
            return nil
        }
    }

}

#Preview {
    AddJournalView(viewModel: JournalViewModel(), selectedTrip: Trip())
}
