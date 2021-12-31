//
//  MainView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    
    init() {
 //       UITabBar.appearance().isTranslucent = false
 //       UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }

    var body: some View {
        TabView {
            BridgeListView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Bridge List", systemImage: "list.dash")
                }
            BridgePhotosView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Bridge Photos", systemImage: "photo.on.rectangle")
                }
            BridgeMapView()
                .tabItem {
                    Label("Bridge Map", systemImage: "map")
                }
        }
        .onAppear {
            bridgeStore.refreshBridgeModels()
        }
//        .accentColor(Color.pbAccent)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BridgeStore())
    }
}
    
