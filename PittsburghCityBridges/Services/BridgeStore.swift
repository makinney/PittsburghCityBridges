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
final class BridgeStore: ObservableObject {
    @Published var bridgeModels = [BridgeModel]()
    private let openDataService: OpenDataService

    let logger: Logger
    init() {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
        openDataService = OpenDataService()
    }
    
    @MainActor
    func loadBridgeModels() {
        Task {
            var freshModels = [BridgeModel]()
            do {
                if let jsonData = await self.openDataService.getBridgeModelOpenData() {
                    let geoJSONObjects = try MKGeoJSONDecoder().decode(jsonData)
                    for object in geoJSONObjects {
                        if let feature = object as? MKGeoJSONFeature,
                           let propertyData = feature.properties {
                            let geometry = feature.geometry
                            let geoJSONProp: GeoJSONProperty = try JSONDecoder().decode(GeoJSONProperty.self, from: propertyData)
                            let bridgeModel = BridgeModel(geometry: geometry, geoJSON: geoJSONProp)
                            freshModels.append(bridgeModel)
                        }
                    }
                    self.bridgeModels = freshModels // Publish
                }
            } catch let error {
                logger.error("\(#file) \(#function) \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
#if DEBUG
    @MainActor
    func preview() {
        loadBridgeModels()
    }
#endif
    
}

extension BridgeStore {
    func sortedByName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            return model1.name < model2.name
        }
        return sortedModels
    }
    
    func sortedByYearAndName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            guard model1.yearBuilt == model2.yearBuilt else {
                return model1.yearBuilt < model2.yearBuilt
            }
            return model1.name < model2.name
        }
        return sortedModels
    }
    
    func sortedByNeighborhoodAndName() -> [BridgeModel] {
        let sortedModels = bridgeModels.sorted { model1, model2 in
            guard model1.startNeighborhood == model2.startNeighborhood else {
                return model1.startNeighborhood < model2.startNeighborhood
            }
            return model1.name < model2.name
        }
        return sortedModels
    }
}
