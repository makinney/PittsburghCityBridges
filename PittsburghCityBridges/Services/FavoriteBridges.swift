//
//  FavoritesStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/5/22.
//

import SwiftUI
import os

@MainActor final class FavoriteBridges: ObservableObject {
    
    @Published var favoritesChanged = 0
    private var favorites = Set<String>()
    @AppStorage("favorites.bridge.store") private var persistentStore = Data()
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        favorites = loadFavorites()
    }
    
    func addFavorite(name: String) {
        if favorites.insert(name).inserted == true {
            save(favorites)
        }
        favoritesChanged += 1
    }
    
    func removeFavorite(name: String) {
        favorites.remove(name)
        save(favorites)
        favoritesChanged += 1
    }
    
    func isFavorite(name: String) -> Bool {
        return favorites.contains(name)
    }
    
    private func save(_ favorites: Set<String>) {
        let favs = Array(favorites)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favs)
            persistentStore = data
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")        }
    }
    
    private func loadFavorites() -> Set<String> {
        var favorites = [String]()
        do {
            let decoder = JSONDecoder()
            favorites = try decoder.decode([String].self, from: persistentStore)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return Set(favorites)
    }
}
