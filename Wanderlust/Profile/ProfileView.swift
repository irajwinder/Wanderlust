//
//  ProfileView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var profilePicture: UIImage? = UIImage(named: "logo")
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        CustomImage(profilePicture: profilePicture)
                    }
                    Spacer()
                }
                Form {
                    Section(header: Text("Personal Information")) {
                        CustomText(text: "Name", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "Full Name", text: $userName)
                            .padding()
                        
                        CustomText(text: "Email", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "Email", text: $email)
                            .padding()
                        
                        CustomText(text: "Date of Birth", textSize: 20, textColor: .black)
                        CustomDatePicker()
                            .padding()
                    }
                }
            }.navigationBarTitle("User Profile")
                .toolbar {
                    ToolbarItem {
                        Button(action: {}) {
                            Label("Save", systemImage: "plus")
                        }
                    }
                }
        }
    }
}


#Preview {
    ProfileView()
}
