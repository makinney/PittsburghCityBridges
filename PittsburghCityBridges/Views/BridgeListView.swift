//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeStore: BridgeStore

    var body: some View {
        NavigationView {
            List {
                ForEach(bridgeStore.bridgeModels) { bridgeModel in
                    NavigationLink(bridgeModel.name, destination: BridgeDetailsView(bridgeModel: bridgeModel))
                }
            }
            .navigationTitle("City Bridges")
        }
    }
}

struct BridgeListView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeListView()
            .environmentObject(bridgeStore) // TODO: canned data
            .onAppear {
                bridgeStore.preview()
            }
    }
    
    static func update() {
        bridgeStore.preview()
    }
}
