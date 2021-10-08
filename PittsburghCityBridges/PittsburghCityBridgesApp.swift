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
        bridges = Bridges()
    }
    
//    let persistenceController = PersistenceController.shared
    @ObservedObject var bridges: Bridges
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bridges)
  //          CloudKitContentView()
 //              .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
