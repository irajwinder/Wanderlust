//
//  Validation.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/3/23.
//

import SwiftUI

struct Validation {
    static func isValidName(_ name: String?) -> Bool {
        guard let name = name, !name.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String?) -> Bool {
        guard let password = password, password.count >= 8 else {
            return false
        }
        return true
    }

    static func doPasswordsMatch(_ password: String?, _ confirmPassword: String?) -> Bool {
        guard let password = password, let confirmPassword = confirmPassword, password == confirmPassword else {
            return false
        }
        return true
    }
    
    static func isValidDateOfBirth(_ date: Date) -> Bool {
        return date <= Date() // Checks if the date is not in the future
    }
    
    static func isValidTripStartDate(_ date: Date) -> Bool {
        return date >= Date() // Checks if the date is not in the past
    }
    
    static func isValidTripEndDate(_ endDate: Date, startDate: Date) -> Bool {
        return endDate > startDate
    }

    static func showAlert(title: String, message: String) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
    }
    
    static func dateToString(_ date: Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if let startDate = date {
            return dateFormatter.string(from: startDate)
        } else {
            return "N/A"
        }
    }
}
