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
    @StateObject var bridgeStore: BridgeStore = BridgeStore()
    @StateObject var favoriteBridges: FavoriteBridges = FavoriteBridges()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridgeStore)
                .environmentObject(favoriteBridges)
  // CloudKitContentView()
 //        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
