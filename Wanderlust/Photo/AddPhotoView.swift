//
//  AddPhotoView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    let selectedTrip: Trip?
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PhotoViewModel
    
    @State private var galleryPhotos: [String] = []
    @State private var photoTag: String = ""
    @State private var photoCaption: String = ""
    
    @State private var selectedPickerImages: [PhotosPickerItem] = []
    @State private var galleryPhotoImages: [Image] = []
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Trip Photo(s)")) {
                        HStack {
                            CustomText(text: "Trip Pictures", textSize: 20, textColor: .black)
                            Spacer()
                            
                            PhotosPicker(
                                "Select photo",
                                selection: $selectedPickerImages,
                                maxSelectionCount: 5,
                                matching: .images
                            )
                            
                        }.onChange(of: selectedPickerImages) { selectedItems in
                            Task {
                                for selectedItem in selectedItems {
                                    if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            let galleryImage = Image(uiImage: uiImage)
                                            galleryPhotoImages.append(galleryImage)
                                            // Save image to file manager and get the URL
                                            if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "GalleryPictures", fileName: "\(UUID().uuidString).jpg") {
                                                galleryPhotos.append(imageURL)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100)),
                            GridItem(.adaptive(minimum: 100))
                        ]) {
                            ForEach(galleryPhotoImages.indices, id: \.self) { index in
                                galleryPhotoImages[index]
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
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
                    }
                }
            }.navigationBarTitle("Add Photo")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save", action: {
                            SaveAndValidatePhoto()
                        })
                    }
                }
                .alert(isPresented: $showAlert) {
                    alert!
                }
        }
    }
    
    func SaveAndValidatePhoto() {
        guard !galleryPhotos.isEmpty else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select trip photos")
            return
        }
        
        guard Validation.isValidName(photoCaption) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please add photos Caption")
            return
        }
        
        guard Validation.isValidName(photoTag) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please add photos Tag")
            return
        }
        
        guard let selectedTrip = selectedTrip else {
            print("Could not fetch")
            return
        }
        
        // Save Photo Details
        for photoURL in galleryPhotos {
            dataManagerInstance.savePhoto(
                tripName: selectedTrip,
                imageData: photoURL,
                photoCaption: photoCaption,
                photoTag: photoTag
            )
        }
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Dismiss the sheet after saving the trip
        dismiss()
        
        // Update the trips in the ViewModel
        viewModel.fetchPhotos()
    }
}

#Preview {
    AddPhotoView(selectedTrip: Trip(), viewModel: PhotoViewModel())
}
