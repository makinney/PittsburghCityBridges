//
//  ContentView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridgeService: BridgeService
    var body: some View {
        Text("City Bridges")
        List {
            ForEach(bridgeService.bridgeViewModels) { bridgeViewModel in
                Text("\(bridgeViewModel.name)")
            }
        }
        .onAppear {
            bridgeService.refreshBridgeViewModels()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
