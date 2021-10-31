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
                ForEach(bridgeStore.groupByNeighborhood()) { bridgeGroup in
                    Section("\(bridgeGroup.groupName)") {
                        ForEach(bridgeGroup.bridgeModels) { bridgeModel in
                            NavigationLink(destination: BridgeDetailsView(bridgeModel: bridgeModel)) {
                                BridgeListRow(bridgeModel: bridgeModel)
                            }
                        }
                        .font(.body)
                    }
                    .font(.headline)
                    
                }
            }
            .navigationTitle("City Bridges")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BridgeListView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeListView()
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
        BridgeListView()
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
