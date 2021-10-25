//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import os

struct BridgeDetailsView: View {
    var bridgeModel: BridgeModel
    var imageLoader: UIImageLoader = UIImageLoader()
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.headline) .padding([.leading, .bottom])
                    let built = bridgeModel.builtHistory()
                    if !built.isEmpty {
                        Text(built)
                            .padding([.leading, .bottom])
                    }
                    Text(bridgeModel.neighborhoods())
                        .padding([.leading])
                    BridgeMapUIView(region: CityModel.singleBridgeRegion, bridgeModels: [bridgeModel], hasDetailAccessoryView: false)
                        .padding()
                        .frame(width: geometry.size.width, height: 200)
                    BridgeImageView(imageLoader: imageLoader, imageURL: bridgeModel.imageURL)
                        .padding()
                }
            }
        }
    }
    
    struct BridgeImageView: View {
        @ObservedObject var imageLoader: UIImageLoader
        var imageURL: URL?
        var body: some View {
            switch imageLoader.state {
            case .idle:
                Color.clear
                    .onAppear {
                        imageLoader.load(imageURL)
                    }
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .failed(let error):
                Text(error)
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
    
    
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
            .preferredColorScheme(.dark)
    }
}
