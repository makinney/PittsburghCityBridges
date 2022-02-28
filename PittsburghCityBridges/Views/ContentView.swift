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
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.pbBgnd)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView {
            BridgeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            BridgesPhotosListView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle")
                }
            BridgesListsView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
            MoreScreenView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
        }
        .environmentObject(favorites)
        .onAppear {
            Task {
                await bridgeStore.loadBridgeModels()
                await bridgeStore.downloadBridgeModelOpenData()
            }
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

