//
//  DetailAccessoryView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//
import SwiftUI

struct BridgeMapDetailAccessoryView: View {
    var bridgeModel: BridgeModel
    var body: some View {
        Image("HultonBridge")
            .resizable()
            .scaledToFit()
    }
}

struct DetailAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeMapDetailAccessoryView(bridgeModel: BridgeModel.preview)
    }
}
