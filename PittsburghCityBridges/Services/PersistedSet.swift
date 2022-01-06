//
//  FavoritesStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 1/5/22.
//

import SwiftUI
import os

@MainActor final class PersistedSet: ObservableObject {
    
    @AppStorage("favorites.bridge.store") private var thePersistedData = Data()
    private var workingSet = Set<String>()
    @Published var setUpdated = 0
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        workingSet = loadPersistedData()
    }
    
    func add(element: String) {
        if workingSet.insert(element).inserted == true {
            save(setElements: workingSet)
        }
        setUpdated += 1
    }
    

    func remove(element: String) {
        if let _ = workingSet.remove(element) {
            save(setElements: workingSet)
        }
        setUpdated += 1
    }
    
    func contains(element: String) -> Bool {
        return workingSet.contains(element)
    }
    
    private func save(setElements: Set<String>) {
        let favs = Array(setElements) // cannot store sets directly into UserDefaults
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favs)
            thePersistedData = data
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")        }
    }
    
    private func loadPersistedData() -> Set<String> {
        var favorites = [String]()
        do {
            let decoder = JSONDecoder()
            favorites = try decoder.decode([String].self, from: thePersistedData)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return Set(favorites)
    }
}
