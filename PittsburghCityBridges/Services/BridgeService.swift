//
//  BridgeService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import MapKit
import os

@MainActor
class BridgeService: ObservableObject {
    @Published var bridgeModels = [BridgeModel]()
    let logger: Logger
    init() {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    }
    
    @MainActor
    func refreshBridgeModels()  {
        Task {
            do {
                let urlPath = try await OpenDataService().openDataURL
                guard let url = URL(string: urlPath) else {
                    logger.error("Could not create URL from path \(urlPath, privacy: .public)")
                    return
                }
                loadViewModelsFrom(url: url)
            } catch let error {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    @MainActor
    func loadViewModelsFrom(url: URL) {
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
                logger.info("refreshed \(self.bridgeModels)")
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
        loadViewModelsFrom(url: url)
    }
#endif
    
}
