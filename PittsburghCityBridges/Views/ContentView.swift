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
                    Label("Lists", systemImage: "list.dash")
                }
            BridgePhotosView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            BridgeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        .onAppear {
            bridgeStore.refreshBridgeModels()
        }
        .accentColor(.orange)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BridgeStore())
    }
}
    
