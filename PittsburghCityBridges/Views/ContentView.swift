//
//  MainView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    @StateObject var favorites: Favorites = Favorites()

    init() {
        UITabBar.appearance().backgroundColor = UIColor.pbTabBarBackground
    }

    var body: some View {
        TabView {
            BridgesListsView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Bridge List", systemImage: "list.dash")
                }
            BridgesPhotosListView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Bridge Photos", systemImage: "photo.on.rectangle")
                }
            BridgeMapView()
                .tabItem {
                    Label("Bridge Map", systemImage: "map")
                }
            MoreScreenView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
        .environmentObject(favorites)
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
            .environmentObject(Favorites())
    }
}
    
