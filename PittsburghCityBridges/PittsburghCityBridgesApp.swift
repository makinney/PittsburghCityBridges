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
 //   let fileServices: FileServices
    
    init() {
//        do {
//            try fileServices = FileServices()
//        } catch {
//            fatalError("failed to create file services \(error.localizedDescription)")
//        }
        bridgeStore = BridgeStore()
    }
    
    @ObservedObject var bridgeStore: BridgeStore
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridgeStore)
            
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
