//
//  FavoritesButton.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI

struct FavoritesButton: View {
    @ObservedObject var favorites: Favorites
    private var favorite: String
    init(_ favorites: Favorites, favorite: String) {
        self.favorites = favorites
        self.favorite = favorite
    }
    
    var body: some View {
        return VStack {
            Button {
                if favorites.contains(element: favorite) {
                    self.favorites.remove(element: favorite)
                } else {
                    self.favorites.add(element: favorite)
                }
            } label: {
                if favorites.contains(element: favorite) {
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
        FavoritesButton(Favorites(), favorite: name)
    }
}
