//
//  SinglePhotoView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//
import SwiftUI

struct SinglePhotoView: View {
    @State var bridgeImage = UIImage()
    @State var imageLoaded = false
    private var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let pbColorPalate: PBColorPalate
    private let imageCornerRadius: CGFloat = 10
    private let imageURL: URL

    init(imageURL: URL, bridgeModel: BridgeModel, pbColorPalate: PBColorPalate) {
        self.bridgeModel = bridgeModel
        self.pbColorPalate = pbColorPalate
        self.imageURL = imageURL
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(bridgeModel.name)")
                    .font(.headline)
                    .foregroundColor(pbColorPalate.textFgnd)
                    .opacity(imageLoaded ? 1.0 : 0.0)
                Spacer()
            }
            ZStack {
                Image(uiImage: bridgeImage )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(imageCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: imageCornerRadius)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    .opacity(imageLoaded ? 1.0 : 0.0)
                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                    .opacity(imageLoaded ? 0.0 : 1.0)
            }
        }
        .padding([.horizontal])
        .frame(width: UIScreen.main.bounds.size.width)
        .frame(height: UIScreen.main.bounds.size.width * 0.75)  // fraction of width
        .padding([.leading, .trailing, .bottom])
        .background(pbColorPalate.textBgnd)
        .onAppear {
            Task {
                do {
                    if imageLoaded == false {
                        if let image = await bridgeImageSystem.getThumbnailImage(url:imageURL, desiredThumbnailWidth: 1000) {
                            bridgeImage = image
                            imageLoaded = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            bridgeImage = UIImage()
            imageLoaded = false
        }
    }
}


struct SinglePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TODO preview Needs implemented")
   //     SinglePhotoView()
    }
}
