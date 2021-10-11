//
//  BridgeListView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//

import SwiftUI

struct BridgeListView: View {
    @EnvironmentObject var bridgeService: BridgeService

    var body: some View {
        List {
            ForEach(bridgeService.bridgeViewModels) { bridgeViewModel in
                VStack(alignment: .leading) {
                    Text("\(bridgeViewModel.name)")
                    Text("\(bridgeViewModel.neighborhoodRoute)")
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct BridgeListView_Previews: PreviewProvider {
    static let bridgeService = BridgeService()
    static var previews: some View {
        BridgeListView()
            .environmentObject(bridgeService) // TODO: canned data
           
    }
    
    static func update() {
        bridgeService.refreshBridgeViewModels()
    }
}
