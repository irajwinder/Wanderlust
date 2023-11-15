//
//  WanderlustApp.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

@main
struct WanderlustApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn == true {
                TabBarView()
            } else {
                Register()
            }
        }
    }
}
