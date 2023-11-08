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
                    LoginView()                }
            }
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    // @AppStorage to store the login status
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomTextField(placeholder: "Email", text: $email)
                    .padding()
                
                CustomSecureTextField(placeholder: "Password", text: $password)
                    .padding()
            }
        }
        .navigationTitle("Login")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Login", action: {
                    validateUser()
                })
            }
        }.alert(isPresented: $showAlert) {
            alert!
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            TabBarView()
        }
    }
    
    func validateUser() {
        guard Validation.isValidEmail(email) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid email address")
            return
        }
        
        guard let user = dataManagerInstance.fetchUser(userEmail: email), Validation.isValidEmail(email) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "User not found")
            return
        }
        
        guard Validation.isValidPassword(password) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Password must be at least 8 characters long")
            return
        }
        
        guard password == user.userPassword else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Incorrect password")
            return
        }
        
        //Logged in Successfully
        isLoggedIn = true
    }
}

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
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
        }.navigationTitle("Register")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: {
                        validateUser()
                    })
                }
            }.alert(isPresented: $showAlert) {
            alert!
        }
    }
    
    func validateUser() {
        guard Validation.isValidEmail(email) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Invalid email address")
            return
        }
        
        guard Validation.isValidPassword(password) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Password must be at least 8 characters long")
            return
        }
        
        guard Validation.doPasswordsMatch(password, confirmPassword) else {
            showAlert = true
            alert = Validation.showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        // Save user Details
        dataManagerInstance.saveUser(
            userName: "",
            userEmail: email,
            userPassword: password,
            userDateOfBirth: Date(),
            userProfilePhoto: Data()
        )
        
        // Show a success alert
        showAlert = true
        alert = Validation.showAlert(title: "Success", message: "Successfully Saved the data")
        
        // Clear the text fields on successful submission
        email = ""
        password = ""
        confirmPassword = ""
    }
}


struct UserListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.userEmail, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>

    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Text(user.userEmail ?? "")
                Text(user.userPassword ?? "")
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
