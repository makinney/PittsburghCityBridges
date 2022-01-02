//
//  BridgeMapView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/10/21.
//
import MapKit
import SwiftUI

struct BridgeMapView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    var body: some View {
        VStack(spacing: 0){
            TitleHeader(title: "Bridges Map")
                .padding([.bottom], 5)
            BridgeMapUIView(region: MapViewModel().multipleBridgesRegion, bridgeModels: bridgeStore.bridgeModels, showsBridgeImage: true)
        }
    }
}

struct BridgeMapView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeMapView()
            .environmentObject(bridgeStore)
        .onAppear {
            bridgeStore.preview()
        }
    }
}
