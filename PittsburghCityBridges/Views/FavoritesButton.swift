//
//  FavoritesButton.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI

struct FavoritesButton: View {
    
    @ObservedObject var favoriteBridges: FavoriteBridges
    private var bridgeName: String
    private var isFavorite = false
    init(_ favoriteBridges: FavoriteBridges, bridgeName: String) {
        self.favoriteBridges = favoriteBridges
        self.bridgeName = bridgeName
        isFavorite = favoriteBridges.isFavorite(name: bridgeName)
    }
    
    var body: some View {
        return VStack {
            Button {
                if isFavorite {
                    self.favoriteBridges.removeFavorite(name: bridgeName)
                } else {
                    self.favoriteBridges.addFavorite(name: bridgeName)
                }
            } label: {
                if isFavorite {
                    Label("Favorite", systemImage: "star.fill")
                } else {
                    Label("Favorite", systemImage: "star")
                    
                }
            }
        }
    }
}

struct FavoritesButton_Previews: PreviewProvider {
    static let name = "ABC"
    static var previews: some View {
        FavoritesButton(FavoriteBridges(), bridgeName: name)
    }
}
