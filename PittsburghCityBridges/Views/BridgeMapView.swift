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
        MapView(region: CityModel.region, bridgeStore: bridgeStore)
        }
        .onAppear {
            bridgeStore.refreshBridgeModels()
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
