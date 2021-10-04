//
//  BridgeProperties.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import Foundation

struct CityBridges: Codable {
    var crs: CRS?
    var name: String?
    var bridges: [Bridge] = []
    var featuresName: String?
}

extension CityBridges {
    enum CodingKeys: String, CodingKey {
        case crs
        case bridges = "features"
        case featuresName = "type"
        case name
    }
}

struct CRS: Codable {
    var properties: [String: String]
    var crsType: String
}

extension CRS {
    enum CodingKeys: String, CodingKey {
        case properties
        case crsType = "type"
    }
}

struct Bridge: Codable, Identifiable {
    var id: Int
    var geometry: BridgeGPSCoordinates
    var properties: BridgeProperties
    var typeFeature: String
}

extension Bridge {
    enum CodingKeys: String, CodingKey {
        case id
        case geometry
        case properties
        case typeFeature = "type"
    }
}

struct BridgeGPSCoordinates: Codable {
    var coordinates: [[Double]]
    var geometryType: String
}

extension BridgeGPSCoordinates {
    enum CodingKeys: String, CodingKey {
        case coordinates
        case geometryType = "type"
    }
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
