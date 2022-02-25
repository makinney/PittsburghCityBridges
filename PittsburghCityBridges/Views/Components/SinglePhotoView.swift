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
    private let imageCornerRadius: CGFloat = 10
    private let imageURL: URL

    init(imageURL: URL, bridgeModel: BridgeModel) {
        self.bridgeModel = bridgeModel
        self.imageURL = imageURL
        bridgeImageSystem = BridgeImageSystem()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(bridgeModel.name)")
                    .font(.headline)
                    .foregroundColor(Color.pbTextFnd)
                    .opacity(imageLoaded ? 1.0 : 0.0)
                Spacer()
            }
            ZStack {
                HStack {
                    Image(uiImage: bridgeImage )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(imageCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: imageCornerRadius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                    Spacer()
                    VStack {
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                }
                .opacity(imageLoaded ? 1.0 : 0.0)
                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                    .opacity(imageLoaded ? 0.0 : 1.0)
            }
        }
        .padding([.horizontal])
        .frame(width: UIScreen.main.bounds.size.width)
        .frame(height: UIScreen.main.bounds.size.width * 0.75)  // need to fix size since do not know image size
        .background(Color.pbBgnd)
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
