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
                    Label("List", systemImage: "list.dash")
                }
            BridgeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            BridgesPhotosListView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            MoreScreenView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
        .environmentObject(favorites)
        .onAppear {
            bridgeStore.loadBridgeModels()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BridgeStore())
            .environmentObject(Favorites())
    }
}
    
