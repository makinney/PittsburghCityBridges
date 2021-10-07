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
    init() {
        bridgeDataStore = BridgeDataStore()
    }
    
//    let persistenceController = PersistenceController.shared
    @ObservedObject var bridgeDataStore: BridgeDataStore
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridgeDataStore)
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
