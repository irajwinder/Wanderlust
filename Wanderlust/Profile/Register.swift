//
//  Register.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI
import CoreData

struct Register: View {
    @State private var selectedTab = 0 // 0 for Register, 1 for Login
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select View", selection: $selectedTab) {
                    Text("Register").tag(0)
                    Text("Login").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    RegisterView()
                } else {
                    LoginView().toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Login", action: {
                                isLoggedIn = true
                            })
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                TabBarView()
            }
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CustomTextField(placeholder: "Email", text: $email)
                    .padding()
                
                CustomSecureTextField(placeholder: "Password", text: $password)
                    .padding()
            }
        }.navigationTitle("Login")
    }
}

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CustomTextField(placeholder: "Email", text: $email)
                    .padding()
                
                CustomSecureTextField(placeholder: "Password", text: $password)
                    .padding()
                
                CustomSecureTextField(placeholder: "Confirm Password", text: $confirmPassword)
                    .padding()
            }
        }.navigationTitle("Register").toolbar {
            ToolbarItem {
                Button(action: {
                    if Validation.isValidEmail(email) {
                        if Validation.isValidPassword(password) {
                            if Validation.doPasswordsMatch(password, confirmPassword) {
                                //Save user Details
                                dataManagerInstance.saveUser(
                                    userName: "",
                                    userEmail: email,
                                    userPassword: password,
                                    userDateOfBirth: Date(),
                                    userProfilePhoto: Data()
                                )
                            } else {
                                // Show an alert if passwords do not match
                                Validation.showAlert(on: UIViewController(), with: "Error", message: "Passwords do not match")
                            }
                        } else {
                            // Show an alert if the password is invalid
                            Validation.showAlert(on: UIViewController(), with: "Error", message: "Password must be at least 8 characters long")
                        }
                    } else {
                        // Show an alert if the email is invalid
                        Validation.showAlert(on: UIViewController(), with: "Error", message: "Invalid email address")
                    }
                    
                }) {
                    Label("Save", systemImage: "plus")
                }
            }
        }
    }
}


struct UserListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userName, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>

    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Text(user.userName ?? "")
                Text(user.userEmail ?? "")
            }
        }
    }
}


#Preview {
    Group {
        Register()
        UserListView()
    }
}
