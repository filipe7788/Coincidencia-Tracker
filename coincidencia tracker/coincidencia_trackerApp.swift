//
//  coincidencia_trackerApp.swift
//  coincidencia tracker
//
//  Created by Filipe Cruz on 08/02/23.
//

import SwiftUI

@main
struct coincidencia_trackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
