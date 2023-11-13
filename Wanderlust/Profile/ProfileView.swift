//
//  ProfileView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userDOB = Date()
    @State private var profilePhoto: String?
    
    @AppStorage("isLoggedIn") var isLoggedIn = true
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var profilePhotoImage: Image?
    @State private var userProfilePicture: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        CustomImage(profilePicture: userProfilePicture)
                    }
                    Spacer()
                }
                Form {
                    Section(header: Text("Personal Information")) {
                        HStack {
                            CustomText(text: "Name", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Full Name", text: $userName)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Email", textSize: 20, textColor: .black)
                            CustomTextField(placeholder: "Email", text: $userEmail)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Date of Birth", textSize: 20, textColor: .black)
                            CustomDatePicker(selectedDate: $userDOB)
                                .padding()
                        }
                        
                        HStack {
                            CustomText(text: "Profile Picture", textSize: 20, textColor: .black)
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
                                        profilePhotoImage = Image(uiImage: uiImage)
                                        // Save image to file manager and get the URL
                                        if let imageURL = saveImageToFileManager(uiImage) {
                                            profilePhoto = imageURL
                                        }
                                        return
                                    }
                                }
                                print("Failed")
                            }
//                            if let data = try? await selectedPickerImage?.loadTransferable(type: Data.self),
//                               let uiImage = UIImage(data: data),
//                               let imageURL = saveImageToFileManager(uiImage) {
//                                profilePhotoImage = Image(uiImage: uiImage)
//                                profilePhoto = imageURL
//                            }

                        }
                        
                        VStack {
                            if let profilePhotoImage {
                                profilePhotoImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                        }
                    }
                }
            }.navigationBarTitle("User Profile")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }.navigationBarItems(trailing:
                Button("Logout") {
                // Perform the logout action
                isLoggedIn = false
            })
        }.onAppear(perform: {
            fetch()
        })
    }
    
    func fetch() {
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID),
              let profilePictureRelativePath = user.userProfilePhoto else {
            print("Failed to fetch user or profile picture path")
            return
        }
        
        userName = user.userName ?? ""
        userEmail = user.userEmail ?? ""
        userDOB = user.userDateOfBirth ?? Date()
        
        // Construct the local file URL by appending the relative path to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(profilePictureRelativePath)

        Task {
            do {
                // Read image data from the local file
                let imageData = try Data(contentsOf: localFileURL)
                userProfilePicture = UIImage(data: imageData)
            } catch {
                print("Error loading image:", error.localizedDescription)
            }
        }
    }
    
    func saveProfile() {
        guard let loggedInUserID = loggedInUserID,
              let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch user")
            return
        }
        
        let profilePicture = profilePhoto ?? (user.userProfilePhoto ?? "")
        
        dataManagerInstance.updateUser(
            user: user,
            userName: userName,
            userEmail: userEmail,
            userDateOfBirth: userDOB,
            profilePicticture: profilePicture
        )
        
        fetch()
        profilePhotoImage = nil
    }
    
    func saveImageToFileManager(_ uiImage: UIImage) -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        let folderName = "ProfilePicture"
        let fileName = "Picture.jpg"
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
    ProfileView()
}
