//
//  ContentView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridges: Bridges
    var body: some View {
        Text("City Bridges")
        List {
            ForEach(bridges.cityBridges) { cityBridge in
                Text("\(cityBridge.properties.name)")
            }
        }
        .onAppear {
            bridges.loadCityBridgeData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
