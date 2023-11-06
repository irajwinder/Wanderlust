//
//  CustomComponents.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/2/23.
//

import SwiftUI

struct CustomText: View {
    var text: String
    var textSize: CGFloat
    var textColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: textSize))
            .foregroundColor(textColor)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct CustomSecureTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct CustomImage: View {
    var profilePicture: UIImage?
    var body: some View {
        VStack {
            Image(uiImage: profilePicture ?? UIImage(systemName: "person.fill")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
        }
    }
}

struct CustomDatePicker: View {
    @State private var selectedDate = Date()
    var body: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.automatic)
            .padding()
    }
}

struct CustomCoverPhoto: View {
    var coverPhoto: UIImage?
    
    var body: some View {
        ZStack {
            if let coverPhoto = coverPhoto {
                Image(uiImage: coverPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
            } else {
                Color.gray
            }
        }
    }
}


#Preview {
    Group {
        CustomText(text: "Text", textSize: 20, textColor: .black)
            .padding()
        
        CustomTextField(placeholder: "Enter text", text: .constant(""))
            .padding()
        
        CustomSecureTextField(placeholder: "Enter text", text: .constant(""))
            .padding()
        
        CustomImage(profilePicture: UIImage(named: "logo"))
            .padding()
        
        CustomDatePicker()
            .padding()

        CustomCoverPhoto(coverPhoto: UIImage(named: "logo"))

    }
}
