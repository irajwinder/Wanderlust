//
//  UserProfile.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

struct UserProfile: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
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
                        CustomText(text: "First Name", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "First Name", text: $firstName)
                            .padding()
                        
                        CustomText(text: "Last Name", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "Last Name", text: $lastName)
                            .padding()
                        
                        CustomText(text: "Email", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "Email", text: $email)
                            .padding()
                        
                        CustomText(text: "Bio", textSize: 20, textColor: .black)
                        CustomTextField(placeholder: "Bio", text: $bio)
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
    UserProfile()
}
