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
    @EnvironmentObject var favorites: Favorites
    @AppStorage("bridgeMap.showFavorites") private var showFavorites = false

    var body: some View {
        VStack(spacing: 0){
            TitleHeader(title: "City Bridges Map")
                .padding([.bottom], 5)
            let bridgeModels = filteredModels(bridgeStore.bridgeModels, favorites, showFavorites)
            BridgeMapUIView(region: MapViewModel().multipleBridgesRegion, bridgeModels: bridgeModels, showsBridgeImage: true)
        }
    }
    
    private func filteredModels(_ bridgeModels: [BridgeModel], _ favorites: Favorites, _ showFavorites: Bool) -> [BridgeModel] {
        var filteredModels = [BridgeModel]()
        if showFavorites {
            filteredModels = bridgeModels.filter { bridgeModel in
                favorites.contains(element: bridgeModel.name)
            }
        } else {
            filteredModels = bridgeModels
        }
        return filteredModels
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
