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
    enum SectionListBy {
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
    
    @MainActor
    func sectionList(_ sectionListBy: SectionListBy) -> [Section] {
        switch sectionListBy {
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
        let sortedByName = bridgeStore.sortedByName()
        let bridgeGroup = Section(sectionName: "A-Z", bridgeModels: sortedByName)
        sections.append(bridgeGroup)
        return sections
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
                    sections.append(Section(sectionName: neighborhood, bridgeModels: Array(bridgeModelSlice)))
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
                    sections.append(Section(sectionName: yearBuilt, bridgeModels: Array(bridgeModelSlice)))
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
