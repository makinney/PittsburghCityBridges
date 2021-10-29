//
//  BridgeImageView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/25/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

struct BridgeImageView: View {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgeImageView")
    var url: URL?
    var options: SDWebImageOptions?
    var body: some View {
        logger.info("\(#file) \(#function) opening image for url \(url?.path ?? "no url")")
        return WebImage(url: url, options: [.scaleDownLargeImages])
            .resizable()
            .indicator(.activity)
    }
    
    init(_ url: URL?, options: SDWebImageOptions = []) {
        self.url = url
        self.options = options
        logger.info("\(#file) \(#function)")
    }
}

struct BridgeImageView_Previews: PreviewProvider {
    @ObservedObject static var bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeImageView(bridgeStore.bridgeModels.first?.imageURL)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
