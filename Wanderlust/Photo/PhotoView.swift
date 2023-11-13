//
//  PhotoView.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import SwiftUI

struct PhotoView: View {
    let selectedTrip: Trip?
    @State private var photoTag: String = ""
    @State private var photoCaption: String = ""
    
    @State private var showAlert = false
    @State private var alert: Alert?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Trip Photo(s)")) {
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
                ToolbarItem {
                    Button("Save", action: {
                        SaveAndValidatePhoto()
                    })
                }
            }
            .alert(isPresented: $showAlert) {
                alert!
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
    }
}

#Preview {
    PhotoView(selectedTrip: Trip())
}
