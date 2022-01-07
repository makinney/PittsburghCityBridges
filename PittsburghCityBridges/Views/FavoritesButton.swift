//
//  FavoritesButton.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/6/22.
//

import SwiftUI

struct FavoritesButton: View {
    @ObservedObject var favorites: Favorites
    enum FavoriteAction {
        case added
        case removed
        case undefined
    }
    private var favorite: String
    @State private var favoriteAction = FavoriteAction.undefined
    init(_ favorites: Favorites, favorite: String) {
        self.favorites = favorites
        self.favorite = favorite
    }
    
    var body: some View {
        HStack {
            userMessage(favoriteAction)
            VStack {
                Button {
                    if favorites.contains(element: favorite) {
                        self.favorites.remove(element: favorite)
                        self.favoriteAction = .removed
                    } else {
                        self.favorites.add(element: favorite)
                        self.favoriteAction = .added
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
    
    private func userMessage(_ favoriteAction: FavoriteAction) -> some View {
        var message = ""
        switch favoriteAction {
        case .added:
            message = "Added to Favorites"
        case .removed:
            message = "Removed from Favorites"
        case .undefined:
            message = ""
        }
        return VStack {
            Text(message)
        }
    }
}

struct FavoritesButton_Previews: PreviewProvider {
    static let name = "ABC"
    static var previews: some View {
        FavoritesButton(Favorites(), favorite: name)
    }
}
