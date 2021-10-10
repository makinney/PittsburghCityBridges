//
//  BridgeService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import MapKit

class BridgeService: ObservableObject {
    @Published var bridgeViewModels = [BridgeViewModel]()
    @MainActor
    func refreshBridgeViewModels()  {
        Task {
            var freshViewModels = [BridgeViewModel]()
            let urlPath = try await OpenDataService().openDataURL
            guard let url = URL(string: urlPath) else {
                return // TODO: is this ok to do form this task? or better to throw
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url) // TODO: do not ignore the URLresponse
                let geoJSONObjects = try MKGeoJSONDecoder().decode(data)
                for object in geoJSONObjects {
                    if let feature = object as? MKGeoJSONFeature,
                       let id = feature.identifier,
                       let propertyData = feature.properties {
                        let geometry = feature.geometry
                        let geoJSONProp: GeoJSONProperty = try JSONDecoder().decode(GeoJSONProperty.self, from: propertyData)
                        let bridgeViewModel = BridgeViewModel(id: id, geometry: geometry, geoJSON: geoJSONProp)
                        freshViewModels.append(bridgeViewModel)
                    }
                }
                self.bridgeViewModels = freshViewModels // Publish
            } catch let error {
                print(error)
            }
        }
    }
}
