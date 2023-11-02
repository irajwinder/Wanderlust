//
//  Register.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

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
                    RegisterView().toolbar {
                        ToolbarItem {
                            Button(action: {}) {
                                Label("Save", systemImage: "plus")
                            }
                        }
                    }
                } else {
                    LoginView().toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Login", action: {})
                        }
                    }
                }
            }
        }
    }
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CustomTextField(placeholder: "Username", text: $username)
                    .padding()
                
                CustomTextField(placeholder: "Password", text: $password)
                    .padding()
            }
        }.navigationTitle("Login")
    }
}

struct RegisterView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CustomTextField(placeholder: "Username", text: $username)
                    .padding()
                
                CustomTextField(placeholder: "Password", text: $password)
                    .padding()
                
                CustomTextField(placeholder: "Confirm Password", text: $confirmPassword)
                    .padding()
            }
        }.navigationTitle("Register")
    }
}

#Preview {
    Register()
}