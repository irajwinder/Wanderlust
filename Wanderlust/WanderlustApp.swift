//
//  WanderlustApp.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

@main
struct WanderlustApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
                Register()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
