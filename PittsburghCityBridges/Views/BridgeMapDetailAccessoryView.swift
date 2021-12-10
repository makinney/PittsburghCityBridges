//
//  DetailAccessoryView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//
import SwiftUI

struct BridgeMapDetailAccessoryView: View {
   @ObservedObject private var imageLoader: UIImageLoader
    @State var bridgeImage = UIImage()
    var bridgeModel: BridgeModel
    init(bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        imageLoader = UIImageLoader()
    }
 
    var body: some View {
        Image(uiImage: bridgeImage)
            .resizable()
            .frame(width: 200)
            .aspectRatio(1.0, contentMode: .fit)
            .task {
                do {
                    let data = await imageLoader.getImageData(for: bridgeModel.imageURL)
                    if let data = data,
                       let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: CGSize(width: 500, height: 500)) {
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
