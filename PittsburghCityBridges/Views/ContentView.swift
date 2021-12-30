//
//  MainView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridgeStore: BridgeStore

    var body: some View {
        TabView {
            BridgeListView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("List", systemImage: "list.dash")
                }
            BridgeViewsView(BridgeListViewModel(bridgeStore))
                .tabItem {
                    Label("Bridges", systemImage: "waveform")
                }
//            BridgePhotosView(BridgeListViewModel(bridgeStore))
//                .tabItem {
//                    Label("Photos", systemImage: "photo")
//                }
            BridgeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        .onAppear {
            bridgeStore.refreshBridgeModels()
        }
        .accentColor(.blue)
   //     .colorScheme(ColorScheme.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BridgeStore())
    }
}
