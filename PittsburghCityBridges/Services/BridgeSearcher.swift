//
//  BridgeListViewModel.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 11/9/21.
//

import Foundation
import Combine
import os
import SwiftUI

class BridgeSearcher {
    @ObservedObject private var bridgeStore: BridgeStore
    private var cancellable: AnyCancellable?
    let logger: Logger
    struct BridgeModelCategory: Identifiable {
        var id = UUID()
        var sectionName = ""
        var bridgeModels: [BridgeModel]
    }
    enum SearchCategory: Int {
        case name
        case neighborhood
        case year
    }
    
    private var bridgeCategoryByNameCache = [BridgeModelCategory]()
    private var bridgeCategoryByNeighborhoodCache = [BridgeModelCategory]()
    private var bridgeCategoryByYearCache = [BridgeModelCategory]()
    
    init(_ bridgeStore: BridgeStore) {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
        self.bridgeStore = bridgeStore
        clearCacheOnModelChanges()
    }
    
    func sortAndSearch(by searchCategory: SearchCategory, searchText: String? = nil, favorites: Favorites?) -> [BridgeModelCategory] {
        var bridgeModelCategories = sortBridgeModels(by: searchCategory)
        if let favorites = favorites {
            bridgeModelCategories = filterFavorites(bridgeModelCategories: bridgeModelCategories, favorites: favorites)
        }
        if let searchText = searchText, !searchText.isEmpty {
            bridgeModelCategories = search(bridgeModelCategories, for: searchText, in: searchCategory)
        }
        return bridgeModelCategories
    }
    
    private func filterFavorites(bridgeModelCategories: [BridgeModelCategory], favorites: Favorites) -> [BridgeModelCategory] {
        var filteredSections = [BridgeModelCategory]()
        bridgeModelCategories.forEach { bridgeModelCategory in
            let filterModels = bridgeModelCategory.bridgeModels.filter { bridgeModel in
                favorites.contains(element: bridgeModel.name)
            }
            if !filterModels.isEmpty {
                let filteredSection = BridgeModelCategory(id: bridgeModelCategory.id, sectionName: bridgeModelCategory.sectionName, bridgeModels: filterModels)
                filteredSections.append(filteredSection)
            }
        }
        return filteredSections
    }
    
    private func search(_ bridgeModelCategories: [BridgeModelCategory], for searchText: String, in searchCategory: SearchCategory) -> [BridgeModelCategory] {
        var foundSections = [BridgeModelCategory]()
        bridgeModelCategories.forEach { bridgeModelCategory in
            let foundModels = bridgeModelCategory.bridgeModels.filter { bridgeModel in
                var searchField = ""
                switch searchCategory {
                case .name:
                    searchField = bridgeModel.name
                case .neighborhood:
                    searchField = bridgeModel.startNeighborhood
                case .year:
                    searchField = bridgeModel.yearBuilt
                }
                return  searchField.localizedCaseInsensitiveContains(searchText)
            }
            if !foundModels.isEmpty {
                let foundSection = BridgeModelCategory(id: bridgeModelCategory.id, sectionName: bridgeModelCategory.sectionName, bridgeModels: foundModels)
                foundSections.append(foundSection)
            }
        }
        return foundSections
    }
    
    private func sortBridgeModels(by searchCategory: SearchCategory) -> [BridgeModelCategory] {
        switch searchCategory {
        case .name:
            bridgeCategoryByNameCache = bridgeCategoryByNameCache.isEmpty ? sortBridgeCategoryByName() : bridgeCategoryByNameCache
            return bridgeCategoryByNameCache
        case .neighborhood:
            bridgeCategoryByNeighborhoodCache = bridgeCategoryByNeighborhoodCache.isEmpty ? sortBridgeCategoryByNeighborhood() : bridgeCategoryByNeighborhoodCache
            return bridgeCategoryByNeighborhoodCache
        case .year:
            bridgeCategoryByYearCache = bridgeCategoryByYearCache.isEmpty ? sortBridgeCategoryByYear() : bridgeCategoryByYearCache
            return bridgeCategoryByYearCache
        }
    }
    
    func sortBridgeCategoryByName() -> [BridgeModelCategory] {
        var bridgeModelCategories = [BridgeModelCategory]()
        var bridgeModelsSortedByName = bridgeStore.sortedByName()
        var run = true
        while run {
            if let bridgeModel = bridgeModelsSortedByName.first,
               let firstLetterInFirstModel = firstLetterIn(bridgeModel.name) {
                let bridgeModelsSlice = bridgeModelsSortedByName.prefix { bridgeModel in
                    if let firstLetterInNextModel = firstLetterIn(bridgeModel.name) {
                        return firstLetterInFirstModel == firstLetterInNextModel
                    } else {
                        return false
                    }
                }
                if !bridgeModelsSlice.isEmpty {
                    bridgeModelCategories.append(BridgeModelCategory(sectionName: firstLetterInFirstModel,
                                            bridgeModels: Array(bridgeModelsSlice)))
                    bridgeModelsSortedByName.removeFirst(bridgeModelsSlice.count)
                }
            } else {
                run = false
            }
        }
        return bridgeModelCategories
    }
    
    private func firstLetterIn(_ name: String) -> String? {
        if let letter = name.first {
            return String(letter)
        }
        return nil
    }
    
    func sortBridgeCategoryByNeighborhood() -> [BridgeModelCategory] {
        var bridgeModelCategories = [BridgeModelCategory]()
        var sortedByNeighboorhood = bridgeStore.sortedByNeighborhoodAndName()
        var run = true
        while run {
            let neighborhood = sortedByNeighboorhood.first?.startNeighborhood
            if let neighborhood = neighborhood {
                let bridgeModelSlice = sortedByNeighboorhood.prefix { bridgeModel in
                    bridgeModel.startNeighborhood == neighborhood
                }
                if !bridgeModelSlice.isEmpty {
                    bridgeModelCategories.append(BridgeModelCategory(sectionName: neighborhood,
                                            bridgeModels: Array(bridgeModelSlice)))
                    sortedByNeighboorhood.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return bridgeModelCategories
    }
    
    func sortBridgeCategoryByYear() -> [BridgeModelCategory] {
        var bridgeModelCategories = [BridgeModelCategory]()
        var sortedByYear = bridgeStore.sortedByYearAndName()
        var run = true
        while run {
            let yearBuilt = sortedByYear.first?.yearBuilt
            if let yearBuilt = yearBuilt {
                let bridgeModelSlice = sortedByYear.prefix { bridgeModel in
                    bridgeModel.yearBuilt == yearBuilt
                }
                if !bridgeModelSlice.isEmpty {
                    bridgeModelCategories.append(BridgeModelCategory(sectionName: yearBuilt, bridgeModels:Array(bridgeModelSlice)))
                    sortedByYear.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return bridgeModelCategories
    }
    
    private func clearCacheOnModelChanges() {
        cancellable = bridgeStore.$bridgeModels
            .sink() { _ in
                self.bridgeCategoryByNameCache.removeAll()
                self.bridgeCategoryByNeighborhoodCache.removeAll()
                self.bridgeCategoryByYearCache.removeAll()
            }
    }
}
