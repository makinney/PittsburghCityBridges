//
//  Favorites.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/5/22.
//

import SwiftUI
import os

@MainActor
final class Favorites: ObservableObject {
    @Published var setUpdated = 0
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    private lazy var favoritesStore = {
        return FavoritesStore()
    }()
    
    func add(element: String) {
        if favoritesStore.add(element: element) {
            setUpdated += 1
        }
    }
    
    func remove(element: String) {
        if favoritesStore.remove(element: element) {
            setUpdated += 1
        }
    }
    
    func contains(element: String) -> Bool {
        return favoritesStore.contains(element: element)
    }
}

final class FavoritesStore {
    @AppStorage("favorites.bridge.store") private var persistedData: Data?
    private var workingSet = Set<String>()
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        workingSet = loadPersistedData()
    }
    
    func add(element: String) -> Bool {
        if workingSet.insert(element).inserted == true {
            save(elements: workingSet)
            return true
        }
        return false
    }
    
    func remove(element: String) -> Bool {
        if let _ = workingSet.remove(element) {
            save(elements: workingSet) // update persisted value
            return true
        }
        return false
    }
    
    func contains(element: String) -> Bool {
        return workingSet.contains(element)
    }
    
    private func loadPersistedData() -> Set<String> {
        var favorites = [String]()
        do {
            let decoder = JSONDecoder()
            if let persistedData = persistedData {
                favorites = try decoder.decode([String].self, from: persistedData)
            }
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return Set(favorites)
    }
    
    private func save(elements: Set<String>) {
        let favs = Array(elements) // cannot store sets directly into UserDefaults
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favs)
            persistedData = data
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")        }
    }
}

