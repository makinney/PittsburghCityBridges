//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

struct BridgeDetailsViewID: Hashable, Identifiable, Codable {
    let id: Int
    
    static func == (lhs: BridgeDetailsViewID, rhs: BridgeDetailsViewID) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct BridgeDetailsView: View {
    static let bridgeDetailsUserActivityType = "com.mak.pittsburghcitybridges.bridgedetails"
    
    var bridgeModel: BridgeModel
    @Binding var selectedBridgeID: Int?
    @State var imageScale = 1.0
    @State var zoomToggled = false
    
    var imageLoader: UIImageLoader = UIImageLoader()
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
 
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.headline)
                        .padding()
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
                    BridgeImageView(bridgeModel.imageURL)
                        .scaledToFill()
                        .scaleEffect(imageScale)
                        .clipped()
                        .padding([.leading, .trailing])
                        .gesture(MagnificationGesture()
                                    .onChanged({ value in
                            self.imageScale = value
                        })
                        )
                        .gesture(TapGesture(count: 2)
                                    .onEnded({ _ in
                            self.zoomToggled.toggle()
                            self.imageScale = zoomToggled ? 2.0 : 1.0
                        }))
                }
            }
        }
//        .userActivity(BridgeDetailsView.bridgeDetailsUserActivityType,
//                      isActive: bridgeModel.id == selectedBridgeID) { userActivity in
//            describeUserActivity(userActivity)
//        }
    }
    
    
    func describeUserActivity(_ userActivity: NSUserActivity) {
        let returnBridgeDetailsViewID: BridgeDetailsViewID!
  //      if let activityProduct = try? userActivity.typedPayload(BridgeDetailsViewID.self) {
  //          returnBridgeDetailsViewID = BridgeDetailsViewID(id: bridgeModel.id)
   //     } else {
            returnBridgeDetailsViewID = BridgeDetailsViewID(id: bridgeModel.id)
   //     }
        let localizedString =
            NSLocalizedString("ShowBridgeDetails", comment: "Bridge Details with bridge name")
        userActivity.title = String(format: localizedString, bridgeModel.name)
        
        userActivity.isEligibleForHandoff = false
        userActivity.isEligibleForSearch = false
        userActivity.targetContentIdentifier = String(returnBridgeDetailsViewID.id)
        try? userActivity.setTypedPayload(returnBridgeDetailsViewID)
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
        BridgeDetailsView(bridgeModel: BridgeModel.preview, selectedBridgeID: .constant(nil))
            .preferredColorScheme(.dark)
        BridgeDetailsView(bridgeModel: BridgeModel.preview, selectedBridgeID: .constant(nil))
    }
}
