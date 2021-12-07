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
    @ObservedObject var bridgeStore: BridgeStore
    
    init() {
        bridgeStore = BridgeStore()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridgeStore)
      //          .environmentObject(imageLoader)
            
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
