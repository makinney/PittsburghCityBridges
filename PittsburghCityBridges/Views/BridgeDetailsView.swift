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
    @State var imageScale = 1.0
    @State var zoomToggled = false
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .padding(.leading)
                        .font(.title)
                    BridgeImageView(bridgeModel.imageURL)
                        .aspectRatio(1.0, contentMode: .fit)
                        .scaleEffect(imageScale)
                        .clipShape(
                          RoundedRectangle(cornerRadius: 40)
                        )
                        .clipped()
                        .padding([.leading, .trailing])
                        .gesture(MagnificationGesture()
                                    .onChanged({ value in
                            self.imageScale = value
                        })
                        )
                        .gesture(TapGesture(count: 1)
                                    .onEnded({ _ in
                            self.zoomToggled.toggle()
                            self.imageScale = zoomToggled ? 2.0 : 1.0
                        }))
                    let built = bridgeModel.builtHistory()
                    if !built.isEmpty {
                        Text(built)
                            .padding([.leading,.trailing])
                    }
                    Text(bridgeModel.neighborhoods())
                        .padding([.leading, .trailing, .bottom])
                    makeMapView(bridgeModel)
                        .frame(height: 200)
                        .padding([.leading,.trailing,.bottom])
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
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
