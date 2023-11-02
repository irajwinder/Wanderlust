//
//  WanderlustApp.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/1/23.
//

import SwiftUI

@main
struct WanderlustApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
                Register()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
