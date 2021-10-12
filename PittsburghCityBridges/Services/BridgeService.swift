//
//  BridgeService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import MapKit
import os

class BridgeService: ObservableObject {
    @Published var bridgeViewModels = [BridgeViewModel]()
    let logger: Logger
    init() {
        logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.bridgeService)
    }
    
    @MainActor
    func refreshBridgeViewModels()  {
        Task {
            var freshViewModels = [BridgeViewModel]()
            let urlPath = try await OpenDataService().openDataURL
            guard let url = URL(string: urlPath) else {
                logger.error("Could not create URL from path \(urlPath, privacy: .public)")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let geoJSONObjects = try MKGeoJSONDecoder().decode(data)
                for object in geoJSONObjects {
                    if let feature = object as? MKGeoJSONFeature,
                       let propertyData = feature.properties {
                        let geometry = feature.geometry
                        let geoJSONProp: GeoJSONProperty = try JSONDecoder().decode(GeoJSONProperty.self, from: propertyData)
                        let bridgeViewModel = BridgeViewModel(geometry: geometry, geoJSON: geoJSONProp)
                        freshViewModels.append(bridgeViewModel)
                    }
                }
                self.bridgeViewModels = freshViewModels // Publish
                logger.info("refreshed \(self.bridgeViewModels)")
            } catch let error {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
}
