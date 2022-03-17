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
    private let navBarAppearance = UINavigationBarAppearance()
    private let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    
    init() {
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundColor = UIColor(.pbBgnd)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(.pbTextFnd)]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.pbBgnd)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView {
            BridgesListsView(BridgeSearcher(bridgeStore))
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
            BridgesPhotosListView(BridgeSearcher(bridgeStore))
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            BridgeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            MoreScreenView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
        .environmentObject(favorites)
        .task {
            await bridgeStore.loadBridgeModels()
            await bridgeStore.downloadBridgeModelOpenData()
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

