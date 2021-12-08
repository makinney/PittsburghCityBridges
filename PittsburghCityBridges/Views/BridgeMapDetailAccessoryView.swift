//
//  DetailAccessoryView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//
import SwiftUI

struct BridgeMapDetailAccessoryView: View {
   @ObservedObject private var imageLoader: UIImageLoader
    var bridgeModel: BridgeModel
    init(bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        imageLoader = UIImageLoader()
    }
 
    private func makeImage(_ bridgeModel: BridgeModel, imageLoader: UIImageLoader) -> UIImage {
        var image: UIImage?
        if let data  = imageLoader.uiBridgeImages[imageLoader.imageFileName(bridgeModel.imageURL)] {
            // TODO: a better way to determine size than simple hardcoding, 
            image = UIImage(data: data)?.preparingThumbnail(of: CGSize(width: 500, height: 500))
        }
        return image ?? UIImage()
    }
     
    var body: some View {
        Image(uiImage: makeImage(bridgeModel, imageLoader: imageLoader))
            .resizable()
            .frame(width: 200)
            .aspectRatio(1.0, contentMode: .fit)
            .onAppear {
                imageLoader.loadBridgeImage(for: bridgeModel.imageURL)
            }
            .onDisappear {
                imageLoader.clearImageCache(for: bridgeModel.imageURL)
            }
    }
}

struct DetailAccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("DetailAccessoryView_Previews needs code")
       //  BridgeMapDetailAccessoryView(bridgeModel: BridgeModel.preview)
    }
}
