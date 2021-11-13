//
//  BridgeListRow.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/12/21.
//

import SwiftUI

struct BridgeListRow: View {
    var bridgeModel: BridgeModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let endNeighborhood = bridgeModel.endNeighborhood {
                    Text("including \(endNeighborhood)")
                        .font(.footnote)
                }
                Text(bridgeModel.name)
                    .font(.headline)
                Spacer()
            }
        }
    }
}

struct BridgeListRow_Previews: PreviewProvider {
    static var previews: some View {
        BridgeListRow(bridgeModel: BridgeModel.preview)
    }
}
