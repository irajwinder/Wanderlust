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
    @State private var journalLocation: String = ""
    @State private var journalTimeStamp = Date()
    
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
                            CustomText(text: "Journal Location", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Journal Location", text: $journalLocation)
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
        }
        
    }
    
    func validateJournal() {
        guard Validation.isValidName(journalText) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Journal Name")
            return
        }
        
        guard Validation.isValidName(journalLocation) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid Journal Location")
            return
        }
        
        // Save Journal Details
        dataManagerInstance.saveJournal(
            tripName: selectedTrip!,
            journalText: journalText,
            journalPhoto: Data(),
            journalLocation: journalLocation,
            journalTimeStamp: journalTimeStamp
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
