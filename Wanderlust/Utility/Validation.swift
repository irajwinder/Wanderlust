//
//  Validation.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/3/23.
//

import UIKit

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
            guard let password = password, !password.isEmpty else {
                return false
            }
            return password.count >= 8 //  minimum length as needed.
        }

    static func doPasswordsMatch(password: String?, confirmPassword: String?) -> Bool {
        guard let password = password, let confirmPassword = confirmPassword else {
            return false
        }
        return password == confirmPassword
    }
    
    static func showAlert(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }

}
