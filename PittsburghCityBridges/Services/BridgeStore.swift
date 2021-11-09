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
