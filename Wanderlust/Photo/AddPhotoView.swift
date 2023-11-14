//
//  AddPhotoView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PhotoViewModel
    let selectedTrip: Trip?
   // @State private var galleryPhoto: String?
    @State private var photoTag: String = ""
    @State private var photoCaption: String = ""
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
//    @State private var selectedPickerImage: PhotosPickerItem?
//    @State private var galleryPhotoImage: Image?
    
    @State private var selectedPickerImages: [PhotosPickerItem] = []
    @State private var galleryPhotoImages: [Image] = []
    @State private var galleryPhotos: [String] = []
    
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
                                            if let imageURL = saveImageToFileManager(uiImage) {
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
                        
                        //                    .onChange(of: selectedPickerImage) {
                        //                        Task {
                        //                            if let data = try? await selectedPickerImage?.loadTransferable(type: Data.self) {
                        //                                if let uiImage = UIImage(data: data) {
                        //                                    galleryPhotoImages = Image(uiImage: uiImage)
                        //                                    // Save image to file manager and get the URL
                        //                                    if let imageURL = saveImageToFileManager(uiImage) {
                        //                                        galleryPhoto = imageURL
                        //                                    }
                        //                                    return
                        //                                }
                        //                            }
                        //                            print("Failed")
                        //                        }
                        //                    }
                        
                        //                    VStack {
                        //                        if let galleryPhotoImage {
                        //                            galleryPhotoImage
                        //                                .resizable()
                        //                                .scaledToFit()
                        //                                .frame(width: 50, height: 50)
                        //                        }
                        //                    }
                        
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
        
        guard !galleryPhotos.isEmpty else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Please select trip photos")
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
    
    func saveImageToFileManager(_ uiImage: UIImage) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        let folderName = "GalleryPictures"
        let fileName = "\(UUID().uuidString).jpg"
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
    AddPhotoView(viewModel: PhotoViewModel(), selectedTrip: Trip())
}
