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
            TitleHeader(title: "Pittsburgh City Bridge Locations")
            HStack {
                favoritesMenu()
                Spacer()
                Text(showFavorites ? "Favorites" : "")
                    .foregroundColor(Color.pbTitleTextFgnd)
                    .padding([.trailing])
                    .animation(.easeInOut, value: showFavorites)
            }
            .padding([.leading])
            .padding([.top], 5)
            .padding([.bottom], 10)
            .background(Color.pbTitleTextBgnd)
            let bridgeModels = filtered(bridgeStore.bridgeModels, favorites, showFavorites)
            BridgeMapUIView(region: MapViewModel().multipleBridgesRegion, bridgeModels: bridgeModels, showsBridgeImage: true)
        }
    }
    
    private func favoritesMenu() -> some View {
        Menu(content: {
            Button {
                showFavorites.toggle()
            } label: {
                makeFavoriteLabel("Favorites", showFavorites: showFavorites)
            }
        }, label: {
            Label("Favorites", systemImage: "slider.vertical.3")
                .labelStyle(.iconOnly)
                .font(.title)
        })
    }
    
    private func filtered(_ bridgeModels: [BridgeModel], _ favorites: Favorites, _ showFavorites: Bool) -> [BridgeModel] {
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
    
    private func makeFavoriteLabel(_ name: String, showFavorites: Bool) -> Label<Text, Image> {
        if showFavorites {
            return Label(name, systemImage: "star.fill")
        } else {
            return Label(name, systemImage: "star")
        }
    }
}

struct BridgeMapView_Previews: PreviewProvider {
    static let bridgeStore = BridgeStore()
    static let favorites = Favorites()
    static var previews: some View {
        BridgeMapView()
            .preferredColorScheme(.dark)
            .environmentObject(bridgeStore)
            .environmentObject(favorites)
            .onAppear {
                bridgeStore.preview()
            }
    }
}
