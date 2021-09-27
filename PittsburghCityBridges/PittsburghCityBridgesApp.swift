//
//  PittsburghCityBridgesApp.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import SwiftUI

@main
struct PittsburghCityBridgesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CloudKitContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
