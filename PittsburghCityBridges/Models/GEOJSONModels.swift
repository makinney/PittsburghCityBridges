//
//  GEOJSONModels.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/15/21.
//

import Foundation

struct GeoJSONProperty: Codable {
    var openDataID: Int
    var yearBuilt: String?
    var name: String?
    var yearRehab: String?
    var imagePath: String?
    var startNeighborhood: String?
    var endNeighborhood: String?
}

extension GeoJSONProperty {
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
