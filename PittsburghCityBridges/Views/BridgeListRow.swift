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
                Text(bridgeModel.name)
                    .font(.headline)
                if let endNeighborhood = bridgeModel.endNeighborhood {
                    Text("runs to \(endNeighborhood)")
                        .font(.footnote)
                }
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.primary)
            Spacer()
            VStack {
            Image(systemName: "arrow.forward")
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
