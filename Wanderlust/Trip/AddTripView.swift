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
    
    @State private var isSelectingFromGallery = true
    @State private var imageURL: String = ""
    
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
                            
                            Picker("Source", selection: $isSelectingFromGallery) {
                                Text("Gallery").tag(true)
                                Text("URL").tag(false)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }

                        if isSelectingFromGallery {
                            PhotosPicker(
                                "Select photo",
                                selection: $selectedPickerImage,
                                matching: .images
                            )
                            .onChange(of: selectedPickerImage) {
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
                        } else {
                            TextField("Enter Image URL", text: $imageURL)
                                .padding()
                            
                            if let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 300, height: 300)
                                                .onAppear {
                                                    // Perform asynchronous image loading and save to file manager
                                                    downloadAndSaveImage(url: url)
                                                }
                                        case .failure:
                                            Text("There was an error loading the image")
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            Text("Unknow Error")
                                        }
                                    }.frame(width: 300, height: 300)
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
    
    //download and save an image from the given URL
    func downloadAndSaveImage(url: URL) {
        // Create a data task using URLSession to fetch data from the given URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if there is valid data and convert it to a UIImage
            if let data = data, let uiImage = UIImage(data: data) {
                // Save image to file manager and get the URL
                if let imageURL = fileManagerClassInstance.saveImageToFileManager(uiImage, folderName: "CoverPicture", fileName: "\(UUID().uuidString).jpg") {
                    DispatchQueue.main.async {
                        // Update the coverPhoto property on the main thread
                        coverPhoto = imageURL
                    }
                }
            } else if let error = error {
                print("Error downloading image: \(error)")
            }
        }
        // Resume the data task to initiate the download
        task.resume()
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
