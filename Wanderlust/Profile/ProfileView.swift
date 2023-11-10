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
    
    @AppStorage("isLoggedIn") var isLoggedIn = true
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    
    @State private var selectedPickerImage: PhotosPickerItem?
    @State private var profilePhoto: Image?
    
    @State private var userProfilePicture: UIImage?
    
    @State private var profilePhotoURL: URL?
    
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
                                        profilePhoto = Image(uiImage: uiImage)
                                        // Save image to file manager and get the URL
                                        if let imageURL = saveImageToFileManager(uiImage) {
                                            profilePhotoURL = imageURL
                                        }
                                        return
                                    }
                                }
                                print("Failed")
                            }
                        }
                        
                        VStack {
                            if let profilePhoto {
                                profilePhoto
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
        guard let loggedInUserID = loggedInUserID else {
            print("Could not unwrap")
            return
        }
        guard let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch")
            return
        }
        
        userName = user.userName ?? ""
        userEmail = user.userEmail ?? ""
        userDOB = user.userDateOfBirth ?? Date()

        guard let profilePictureURLString = user.userProfilePhoto,
              let profilePictureURL = URL(string: profilePictureURLString) else {
            print("Could not fetch profile picture URL")
            return
        }

        // Load the image from the URL and assign it to userProfilePicture
        Task {
            if let data = try? await URLSession.shared.data(from: profilePictureURL).0,
               let uiImage = UIImage(data: data) {
                userProfilePicture = uiImage
            }
        }
    }
    
    func saveProfile() {
        guard let loggedInUserID = loggedInUserID else {
            print("Could not unwrap")
            return
        }
        guard let user = dataManagerInstance.fetchUser(userEmail: loggedInUserID) else {
            print("Could not fetch")
            return
        }
        //Update Profile
        dataManagerInstance.updateUser(
            user: user,
            userName: userName,
            userEmail: userEmail,
            userDateOfBirth: userDOB,
            profilePicticture: profilePhotoURL?.absoluteString ?? ""
        )
        
        fetch()
        profilePhoto = nil
    }
    
    func saveImageToFileManager(_ uiImage: UIImage) -> URL? {
        if let imageData = uiImage.jpegData(compressionQuality: 0.5) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let folderName = "ProfilePicture"
            let fileName = "Picture.jpg"
            let fileURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true).appendingPathComponent(fileName)
            do {
                // Create the folder if it doesn't exist
                try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                            
                // Write the image data to the file
                try imageData.write(to: fileURL)
                print("Image saved at: \(fileURL)")
                return fileURL
            } catch {
                print("Error saving image:", error.localizedDescription)
                return nil
            }
        }
        return nil
    }

}


#Preview {
    ProfileView()
}
