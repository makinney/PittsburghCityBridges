//
//  DetailAccessoryView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//
import SwiftUI
import URLImage
import SDWebImageSwiftUI


struct BridgeMapDetailAccessoryView: View {
    var bridgeModel: BridgeModel
    var body: some View {
        //        Image("HultonBridge")
        //            .resizable()
        //            .frame(width: 100, height: 100)
        BridgeImageView(bridgeModel.imageURL)
            .frame(width: 200)
            .aspectRatio(1.0, contentMode: .fit)
    }
}

struct DetailAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeMapDetailAccessoryView(bridgeModel: BridgeModel.preview)
    }
}
