//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
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
                        .font(.headline) .padding([.bottom])
                    let built = bridgeModel.builtHistory()
                    if !built.isEmpty {
                        Text(built)
                    }
                    Text(bridgeModel.neighborhoods())
                        .padding([.bottom])
                    makeMapView(bridgeModel)
                        .frame(width: geometry.size.width, height: 200)
                        .padding([.bottom])
                    BridgeImageView(bridgeModel.imageURL)
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                }
            }
        }
    }
    
    func makeMapView(_ bridgeModel: BridgeModel) -> some View {
        ZStack {
            BridgeMapUIView(region: CityModel.singleBridgeRegion, bridgeModels: [bridgeModel], hasDetailAccessoryView: false)
            Spacer()
            VStack {
                HStack {
                    if let locationCoordinate = bridgeModel.locationCoordinate {
                        Button {
                            DirectionsService().requestDirectionsTo(locationCoordinate)
                        } label: {
                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .padding()
                        Spacer()
                    }
                }
                Spacer()
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
