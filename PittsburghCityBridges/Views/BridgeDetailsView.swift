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
    @State private var bridgeImage = UIImage()
    
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.bridgeStore)
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.headline)
                        .padding([.leading, .bottom])
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
                    Image(uiImage: bridgeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                        .frame(width: geometry.size.width)
                }
            }
        }
        .task {
            if let url = bridgeModel.imageURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    bridgeImage = UIImage(data: data) ?? UIImage()
                } catch let error {
                    logger.error("\(error.localizedDescription)")
                }
            }
        }
    }
    
  
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
