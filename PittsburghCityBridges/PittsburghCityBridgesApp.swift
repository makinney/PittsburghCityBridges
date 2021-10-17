//
//  PittsburghCityBridgesApp.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//
import Combine
import SwiftUI

@main
struct PittsburghCityBridgesApp: App {
    //    let persistenceController = PersistenceController.shared

    init() {
        bridgeStore = BridgeStore()
        bridgeStore.refreshBridgeModels()
    }
    
    @ObservedObject var bridgeStore: BridgeStore
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(bridgeStore)
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
