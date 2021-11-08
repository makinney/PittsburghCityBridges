//
//  BridgeStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import MapKit
import os

@MainActor
class BridgeStore: ObservableObject {
    @Published var bridgeModels = [BridgeModel]()
    struct BridgeGroup: Identifiable {
        var id = UUID()
        var groupName = ""
        var bridgeModels: [BridgeModel]
    }
    enum GroupBy {
        case name
        case neighborhood
        case year
    }
    private var nameGroupCache = [BridgeGroup]()
    private var neighborhoodGroupCache = [BridgeGroup]()
    private var yearGroupCache = [BridgeGroup]()
    
    let logger: Logger
    init() {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    }
    
    @MainActor // TODO: need all these actors?
    func sort(groupBy: GroupBy) -> [BridgeGroup] {
        switch groupBy {
        case .name:
            nameGroupCache = nameGroupCache.isEmpty ? groupByName() : nameGroupCache
            return nameGroupCache
        case .neighborhood:
            neighborhoodGroupCache = neighborhoodGroupCache.isEmpty ? groupByNeighborhood() : neighborhoodGroupCache
            return neighborhoodGroupCache
        case .year:
            yearGroupCache = yearGroupCache.isEmpty ? groupByYear() : yearGroupCache
            return yearGroupCache
        }
    }
    
    @MainActor
    private func sortedByName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            return model1.name < model2.name
        }
        return sortedModels
    }
    
    @MainActor
    private func sortedByYearAndName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            guard model1.yearBuilt == model2.yearBuilt else {
                return model1.yearBuilt < model2.yearBuilt
            }
            return model1.name < model2.name
        }
        return sortedModels
    }
    
    @MainActor
    private func sortedByNeighborhoodAndName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            guard model1.startNeighborhood == model2.startNeighborhood else {
                return model1.startNeighborhood < model2.startNeighborhood
            }
            return model1.name < model2.name
        }
        return sortedModels
    }
    
    func groupByName() -> [BridgeGroup] {
        var bridgesGroup = [BridgeGroup]()
        let sortedByName = sortedByName()
        let bridgeGroup = BridgeGroup(groupName: "A-Z", bridgeModels: sortedByName)
        bridgesGroup.append(bridgeGroup)
        return bridgesGroup
    }
    
    func groupByNeighborhood() -> [BridgeGroup] {
        var bridgesGroup = [BridgeGroup]()
        var sortedByNeighboorhood = sortedByNeighborhoodAndName()
        var run = true
        while run {
            let neighborhood = sortedByNeighboorhood.first?.startNeighborhood
            if let neighborhood = neighborhood {
                let bridgeModelSlice = sortedByNeighboorhood.prefix { bridgeModel in
                    bridgeModel.startNeighborhood == neighborhood
                }
                if !bridgeModelSlice.isEmpty {
                    bridgesGroup.append(BridgeGroup(groupName: neighborhood, bridgeModels: Array(bridgeModelSlice)))
                    sortedByNeighboorhood.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return bridgesGroup
    }
    
    @MainActor
    func groupByYear() -> [BridgeGroup] {
        var bridgesGroup = [BridgeGroup]()
        var sortedByYear = sortedByYearAndName()
        var run = true
        while run {
            let yearBuilt = sortedByYear.first?.yearBuilt
            if let yearBuilt = yearBuilt {
                let bridgeModelSlice = sortedByYear.prefix { bridgeModel in
                    bridgeModel.yearBuilt == yearBuilt
                }
                if !bridgeModelSlice.isEmpty {
                    bridgesGroup.append(BridgeGroup(groupName: yearBuilt, bridgeModels: Array(bridgeModelSlice)))
                    sortedByYear.removeFirst(bridgeModelSlice.count)
                }
            } else { // collection is empty
                run = false
            }
        }
        return bridgesGroup
    }
    
    func refreshBridgeModels()  {
        Task {
            do {
                let urlPath = try await OpenDataService().openDataURL
                guard let url = URL(string: urlPath) else {
                    logger.error("Could not create URL from path \(urlPath, privacy: .public)")
                    return
                }
                loadModelsFrom(url: url)
            } catch let error {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    @MainActor
    func loadModelsFrom(url: URL) {
        Task {
            var freshModels = [BridgeModel]()
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let geoJSONObjects = try MKGeoJSONDecoder().decode(data)
                for object in geoJSONObjects {
                    if let feature = object as? MKGeoJSONFeature,
                       let propertyData = feature.properties {
                        let geometry = feature.geometry
                        let geoJSONProp: GeoJSONProperty = try JSONDecoder().decode(GeoJSONProperty.self, from: propertyData)
                        let bridgeModel = BridgeModel(geometry: geometry, geoJSON: geoJSONProp)
                        freshModels.append(bridgeModel)
                    }
                }
                // update cache
                neighborhoodGroupCache.removeAll()
                nameGroupCache.removeAll()
                yearGroupCache.removeAll()
                self.bridgeModels = freshModels // Publish
                //              logger.info("refreshed \(self.bridgeModels)")
            } catch let error {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
#if DEBUG
    @MainActor
    func preview() {
        guard let url = Bundle.main.url(forResource: "BridgesOpenData", withExtension: "json") else {
            return
        }
        loadModelsFrom(url: url)
    }
#endif
    
}
