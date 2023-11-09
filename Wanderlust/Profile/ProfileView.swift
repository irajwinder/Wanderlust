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
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
//                    VStack {
//                        CustomImage(profilePicture: userProfilePicture)
//                    }
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
                            CustomDatePicker(selectedDate: .constant(Date()))
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
                                        saveImageToFileManager(uiImage)
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
                        //
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
//        if let imageData = user.userProfilePhoto, let uiImage = UIImage(data: imageData) {
//               profilePhoto = Image(uiImage: uiImage)
//           }
        
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
    ProfileView()
}
