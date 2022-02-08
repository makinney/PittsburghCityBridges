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
    @AppStorage(StorageKeys.onBoardingComplete) private var onBoardingComplete = false
    @StateObject var bridgeStore: BridgeStore = BridgeStore()
    
    init() {
        #if DEBUG
        // onBoardingComplete = false
        #endif
    }
    var body: some Scene {
        WindowGroup {
            if onBoardingComplete {
                ContentView()
                    .environmentObject(bridgeStore)
            } else {
                OnBoardingContentView()
            }
            // CloudKitContentView()
            //        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
