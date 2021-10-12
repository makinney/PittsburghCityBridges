//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI

struct BridgeDetailsView: View {
    var bridgeViewModel: BridgeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(bridgeViewModel.name)")
            Text("Built: \(bridgeViewModel.yearBuilt)")
            Text("Rehab: \(bridgeViewModel.yearRehab)")
            Text("Start 'hood: \(bridgeViewModel.startNeighborhood)")
            Text("End 'hood: \(bridgeViewModel.endNeighborhood)")
        }
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeViewModel: BridgeViewModel.preview)
    }
}
