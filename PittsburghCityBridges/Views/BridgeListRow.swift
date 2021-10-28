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
        Text(bridgeModel.name)
            Spacer()
        Text(bridgeModel.yearBuilt)
        }
    }
}

struct BridgeListRow_Previews: PreviewProvider {
    static var previews: some View {
        BridgeListRow(bridgeModel: BridgeModel.preview)
    }
}
