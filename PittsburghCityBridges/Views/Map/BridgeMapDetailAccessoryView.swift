//
//  DetailAccessoryView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//
import SwiftUI

struct BridgeMapDetailAccessoryView: View {
    @State var bridgeImage = UIImage()
    private var bridgeImageSystem: BridgeImageSystem
    var bridgeModel: BridgeModel
    init(bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        VStack {
            Image(uiImage: bridgeImage)
                .resizable()
                .frame(width: 200)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.pbBgnd, lineWidth: 4)
                )
        }
        .task {
            do {
                if let image = await bridgeImageSystem.getThumbnailImage(url: bridgeModel.imageURL, desiredThumbnailWidth: 500) {
                    bridgeImage = image
                }
            }
        }
    }
}

struct DetailAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("DetailAccessoryView_Previews needs code")
        //  BridgeMapDetailAccessoryView(bridgeModel: BridgeModel.preview)
    }
}
