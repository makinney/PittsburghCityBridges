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
        VStack {
            BridgeMapUIView(region: CityModel.region, bridgeModels: bridgeStore.bridgeModels)
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
