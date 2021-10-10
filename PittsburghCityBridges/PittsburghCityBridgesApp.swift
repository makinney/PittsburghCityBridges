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
        bridgeService = BridgeService()
    }
    
//    let persistenceController = PersistenceController.shared
    @ObservedObject var bridgeService: BridgeService
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridgeService)
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
