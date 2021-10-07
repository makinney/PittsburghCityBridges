//
//  ContentView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridgesDataStore: BridgeDataStore
    var body: some View {
        Text("City Bridges")
        List {
            ForEach(bridgesDataStore.bridges) { bridge in
                Text("\(bridge.properties.name)")
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        let cityBridgesCloudkitAccess = CityBridgesCloudKitAccess()
        cityBridgesCloudkitAccess.refreshOpenDataURLs { error in
            if let error = error {
                print(error)
            }
            if let cityBridgesURL = cityBridgesCloudkitAccess.wpOpenData?.cityBridgesURL {
                bridgesDataStore.loadFromNetwork(openDataURL: cityBridgesURL)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
