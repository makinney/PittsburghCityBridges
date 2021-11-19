//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v)}
        return EmptyView()
    }
}

struct BridgeDetailsView: View {
    var bridgeModel: BridgeModel
    var imageLoader: UIImageLoader = UIImageLoader()
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    @State var imageScale = 1.0
    @State var zoomed = false
    var normalY: CGFloat = 400
    
    var body: some View {
        GeometryReader { geometry in
            Print("image geometry local",geometry.frame(in: .local))
            Print("image geometry global",geometry.frame(in: .global))
            VStack(alignment: .leading) {
                Print("zoomed", zoomed)
                Text("ABCD EFGH")
            
                Image("HultonBridge")
                    .offset(y: zoomed ?
                            geometry.frame(in: .local).maxY - geometry.frame(in: .global).midY
                            : 0)
                // .aspectRatio(1.0, contentMode: .fit)
                // .scaleEffect(imageScale)
                //  .position(x: zoomed ? geometry.frame(in: .local).midX : geometry.frame(in: .local).midX,
                //                                      y: zoomed ? geometry.frame(in: .local).midY : normalY)
                    .animation(.easeOut, value: zoomed)
                    .gesture(TapGesture(count: 1)
                                .onEnded({ _ in
                        self.zoomed.toggle()
                    }))
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
        //       BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}


/*
 var body: some View {
 GeometryReader { geometry in
 ScrollView {
 VStack(alignment: .leading) {
 Text("\(bridgeModel.name)")
 .opacity(zoomed ? 0 : 1)
 //              .padding(.leading)
 .font(.title)
 
 BridgeImageView(bridgeModel.imageURL)
 .aspectRatio(1.0, contentMode: .fit)
 //                 .scaleEffect(imageScale)
 .position(x: zoomed ? geometry.frame(in: .local).midX : geometry.frame(in: .local).midX,
 y: zoomed ? geometry.frame(in: .local).midY : 100)
 
 .animation(.easeIn, value: zoomed)
 .animation(.easeIn, value: imageScale)
 //                        .clipShape(
 //                          RoundedRectangle(cornerRadius: 40)
 //                        )
 .clipped()
 //                      .padding([.leading, .trailing])
 //                        .gesture(MagnificationGesture()
 //                                    .onChanged({ value in
 //                            self.imageScale = value
 //                        })
 //                        )
 .gesture(TapGesture(count: 1)
 .onEnded({ _ in
 self.zoomed.toggle()
 //                   self.imageScale = zoomToggled ? 2.0 : 1.0
 }))
 
 let built = bridgeModel.builtHistory()
 if !built.isEmpty {
 Text(built)
 .opacity(zoomed ? 0 : 1)
 //                   .padding()
 }
 Text(bridgeModel.neighborhoods())
 .opacity(zoomed ? 0 : 1)
 //            .padding([.leading, .trailing, .bottom])
 makeMapView(bridgeModel)
 .frame(height: 200)
 .opacity(zoomed ? 0 : 1)
 .clipShape(
 RoundedRectangle(cornerRadius: 40)
 )
 //                  .padding([.leading,.trailing,.bottom])
 }
 .background(Color("SteelersBlack"))
 .foregroundColor(Color("SteelersGold"))
 }
 
 }
 }
 
 */
