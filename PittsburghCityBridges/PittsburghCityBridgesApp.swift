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
        bridges = BridgeService()
        bridges.refreshBridgeModels()
    }
    
    @ObservedObject var bridges: BridgeService
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(bridges)
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
