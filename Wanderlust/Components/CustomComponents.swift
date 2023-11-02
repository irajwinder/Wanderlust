//
//  CustomComponents.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/2/23.
//

import SwiftUI

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

struct CustomButton: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(maxWidth: 200)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    Group {
        CustomTextField(placeholder: "Enter text", text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
        
        CustomButton(label: "Submit", action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
