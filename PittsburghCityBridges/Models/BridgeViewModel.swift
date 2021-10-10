//
//  CityBridge.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import Foundation
import MapKit

struct BridgeViewModel: Identifiable {
    var id: String?
    var geometry: [MKShape & MKGeoJSONObject]
    var geoJSON: GeoJSONProperty

    var openDataID: Int {
        geoJSON.openDataID
    }
    var name: String {
        geoJSON.name ?? "default"
    }
    var imagePath: String? {
        geoJSON.imagePath
    }
    var yearBuilt: String {
        geoJSON.yearBuilt ?? "default"
    }
    var yearRehab: String {
        geoJSON.yearRehab ?? "default"
    }
    var startNeighborhood: String {
        geoJSON.startNeighborhood ?? "default"
    }
    
    var endNeighborhood: String {
        geoJSON.endNeighborhood ?? "default"
    }
    
}

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
