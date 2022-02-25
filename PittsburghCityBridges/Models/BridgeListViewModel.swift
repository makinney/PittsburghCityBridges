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

class BridgeListViewModel {
    @ObservedObject private var bridgeStore: BridgeStore
    private var cancellable: AnyCancellable?
    let logger: Logger
    struct Section: Identifiable {
        var id = UUID()
        var sectionName = ""
        var bridgeModels: [BridgeModel]
    }
    enum BridgeInfoGrouping: Int {
        case name
        case neighborhood
        case year
    }
    
    private var nameSectionCache = [Section]()
    private var neighborhoodSectionCache = [Section]()
    private var yearSectionCache = [Section]()
    
    init(_ bridgeStore: BridgeStore) {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
        self.bridgeStore = bridgeStore
        clearCacheOnModelChanges()
    }
    
    @MainActor func sections(groupedBy: BridgeInfoGrouping, favorites: Favorites?, searchText: String? = nil) -> [Section] {
        var sections = sections(groupedBy: groupedBy)
        if let favorites = favorites {
            sections = filterFavorites(sections: sections, favorites: favorites)
        }
        if let searchText = searchText, !searchText.isEmpty {
            sections = search(sections, for: searchText, in: groupedBy)
        }
        return sections
    }
    
    private func filterFavorites(sections: [Section], favorites: Favorites) -> [Section] {
        var filteredSections = [Section]()
        sections.forEach { section in
            let filterModels = section.bridgeModels.filter { bridgeModel in
                favorites.contains(element: bridgeModel.name)
            }
            if !filterModels.isEmpty {
                let filteredSection = Section(id: section.id, sectionName: section.sectionName, bridgeModels: filterModels)
                filteredSections.append(filteredSection)
            }
        }
        return filteredSections
    }
    
    private func search(_ sections: [Section], for searchText: String, in groupedBy: BridgeInfoGrouping) -> [Section] {
        var foundSections = [Section]()
        sections.forEach { section in
            let foundModels = section.bridgeModels.filter { bridgeModel in
                var searchField = ""
                switch groupedBy {
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
                let foundSection = Section(id: section.id, sectionName: section.sectionName, bridgeModels: foundModels)
                foundSections.append(foundSection)
            }
        }
        return foundSections
    }
    
    private func sections(groupedBy: BridgeInfoGrouping) -> [Section] {
        switch groupedBy {
        case .name:
            nameSectionCache = nameSectionCache.isEmpty ? sectionByName() : nameSectionCache
            return nameSectionCache
        case .neighborhood:
            neighborhoodSectionCache = neighborhoodSectionCache.isEmpty ? sectionByNeighborhood() : neighborhoodSectionCache
            return neighborhoodSectionCache
        case .year:
            yearSectionCache = yearSectionCache.isEmpty ? sectionByYear() : yearSectionCache
            return yearSectionCache
        }
    }
    
    @MainActor
    func sectionByName() -> [Section] {
        var sections = [Section]()
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
                    sections.append(Section(sectionName: firstLetterInFirstModel,
                                            bridgeModels: Array(bridgeModelsSlice)))
                    bridgeModelsSortedByName.removeFirst(bridgeModelsSlice.count)
                }
            } else {
                run = false
            }
        }
        return sections
    }
    
    private func firstLetterIn(_ name: String) -> String? {
        if let letter = name.first {
            return String(letter)
        }
        return nil
    }
    
    @MainActor
    func sectionByNeighborhood() -> [Section] {
        var sections = [Section]()
        var sortedByNeighboorhood = bridgeStore.sortedByNeighborhoodAndName()
        var run = true
        while run {
            let neighborhood = sortedByNeighboorhood.first?.startNeighborhood
            if let neighborhood = neighborhood {
                let bridgeModelSlice = sortedByNeighboorhood.prefix { bridgeModel in
                    bridgeModel.startNeighborhood == neighborhood
                }
                if !bridgeModelSlice.isEmpty {
                    sections.append(Section(sectionName: neighborhood,
                                            bridgeModels: Array(bridgeModelSlice)))
                    sortedByNeighboorhood.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return sections
    }
    
    @MainActor
    func sectionByYear() -> [Section] {
        var sections = [Section]()
        var sortedByYear = bridgeStore.sortedByYearAndName()
        var run = true
        while run {
            let yearBuilt = sortedByYear.first?.yearBuilt
            if let yearBuilt = yearBuilt {
                let bridgeModelSlice = sortedByYear.prefix { bridgeModel in
                    bridgeModel.yearBuilt == yearBuilt
                }
                if !bridgeModelSlice.isEmpty {
                    sections.append(Section(sectionName: yearBuilt, bridgeModels:Array(bridgeModelSlice)))
                    sortedByYear.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return sections
    }
    
    private func clearCacheOnModelChanges() {
        cancellable = bridgeStore.$bridgeModels
            .sink() { _ in
                self.nameSectionCache.removeAll()
                self.neighborhoodSectionCache.removeAll()
                self.yearSectionCache.removeAll()
            }
    }
}
