//
//  BridgeListRow.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/12/21.
//

import SwiftUI

struct BridgeListRow: View {
    @State private var bridgeImage = UIImage()
    @State private var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let imageURL: URL?
    private let imageCornerRadius: CGFloat = 4
    private let imageFrameSize: CGSize
    private let thumbNailSize: CGSize
    private let imageStrokeWidth: CGFloat
    
    init(bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        imageURL = bridgeModel.imageURL
        bridgeImageSystem = BridgeImageSystem()
        if UIDevice.current.userInterfaceIdiom == .phone {
            thumbNailSize = CGSize(width: 200, height: 200)
            imageFrameSize = CGSize(width: 50, height: 50)
            imageStrokeWidth = 1
        } else {
            thumbNailSize = CGSize(width: 500, height: 500)
            imageFrameSize = CGSize(width: 100, height: 100)
            imageStrokeWidth = 2
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                Image(uiImage: bridgeImage )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(imageCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: imageCornerRadius)
                            .stroke(Color.secondary, lineWidth: imageStrokeWidth)
                    )
                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                    .opacity(imageLoaded ? 0.0 : 1.0)
            }
            .frame(width: imageFrameSize.width, height: imageFrameSize.height)
            VStack(alignment: .leading) {
                Spacer()
                Text(bridgeModel.name)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                Spacer()
            }
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "arrow.forward")
                Spacer()
            }
        }
        .onAppear {
            Task {
                do {
                    if let imageURL = bridgeModel.imageURL,
                       imageLoaded == false,
                       let image = await bridgeImageSystem.getThumbnailImage(url:imageURL, size: thumbNailSize) {
                        bridgeImage = image
                        imageLoaded = true
                    }
                }
            }
        }
    }
}

struct BridgeListRow_Previews: PreviewProvider {
    static var previews: some View {
        BridgeListRow(bridgeModel: BridgeModel.preview)
    }
}
