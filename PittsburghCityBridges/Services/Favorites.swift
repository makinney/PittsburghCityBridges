//
//  Favorites.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/5/22.
//

import SwiftUI
import os

@MainActor final class Favorites: ObservableObject {
    
    @AppStorage("favorites.bridge.store") private var persistedData = Data()
    private var workingSet = Set<String>()
    @Published var setUpdated = 0
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        workingSet = loadPersistedData()
    }
    
    func add(element: String) {
        if workingSet.insert(element).inserted == true {
            save(elements: workingSet)
        }
        setUpdated += 1
    }
    

    func remove(element: String) {
        if let _ = workingSet.remove(element) {
            save(elements: workingSet)
        }
        setUpdated += 1
    }
    
    func contains(element: String) -> Bool {
        return workingSet.contains(element)
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
    
    private func loadPersistedData() -> Set<String> {
        var favorites = [String]()
        do {
            let decoder = JSONDecoder()
            favorites = try decoder.decode([String].self, from: persistedData)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return Set(favorites)
    }
}
