//
//  BridgeProperties.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import Foundation
import MapKit

struct CityBridge: Identifiable {
    var id: String?
    var geometry: [MKShape & MKGeoJSONObject]
    var properties: BridgeProperties
}

struct BridgeProperties: Codable {
    var openDataID: Int
    var yearBuilt: String?
    var name: String = ""
    var yearRehab: String?
    var imagePath: String?
    var startNeighborhood: String?
    var endNeighborhood: String?
}

extension BridgeProperties {
    enum CodingKeys: String, CodingKey {
        case openDataID = "id"
        case yearBuilt = "year_built"
        case name
        case yearRehab = "year_rehab"
        case imagePath = "image"
        case startNeighborhood = "start_neighborhood"
        case endNeighborhood = "end_neighborhood"
    }
}
