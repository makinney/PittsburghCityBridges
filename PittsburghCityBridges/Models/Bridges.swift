//
//  BridgeStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import MapKit

class Bridges: ObservableObject {
    @Published var cityBridges = [CityBridge]()
    @MainActor
    func loadCityBridgeData()  {
        Task {
            do {
                var cityBridges = [CityBridge]()
                let urlPath = try await CityBridgesMetaDataService().openDataURL
                guard let url = URL(string: urlPath) else {
                    return // TODO: is this ok to do form this task? or better to throw
                }
                let (data, _) = try await URLSession.shared.data(from: url)
                let geoJSONObjects = try MKGeoJSONDecoder().decode(data)
                for geoJSONObject in geoJSONObjects {
                    if let feature = geoJSONObject as? MKGeoJSONFeature,
                       let id = feature.identifier,
                       let propertyData = feature.properties {
                        let bridgeProperties: BridgeProperties = try JSONDecoder().decode(BridgeProperties.self, from: propertyData)
                        let geometry = feature.geometry
                        let cityBridge = CityBridge(id: id, geometry: geometry, properties: bridgeProperties)
                        cityBridges.append(cityBridge)
                    }
                }
                self.cityBridges = cityBridges
                print(self.cityBridges)
            } catch let error {
                print(error)
            }
        }
    }
}
