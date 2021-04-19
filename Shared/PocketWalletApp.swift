//
//  PocketWalletApp.swift
//  Shared
//
//  Created by Ashli Rankin on 4/18/21.
//

import SwiftUI

@main
struct PocketWalletApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AddEntryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
