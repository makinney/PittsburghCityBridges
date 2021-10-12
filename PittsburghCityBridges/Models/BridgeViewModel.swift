//
//  CityBridge.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 9/27/21.
//

import Foundation
import MapKit

struct BridgeViewModel: Identifiable {
    var id: Int {
        geoJSON.openDataID
    }
    var geometry: [MKShape & MKGeoJSONObject]
    var geoJSON: GeoJSONProperty

    var openDataID: Int {
        geoJSON.openDataID
    }
    var name: String {
        geoJSON.name ?? ""
    }
    var imagePath: String? {
        geoJSON.imagePath
    }
    var yearBuilt: String {
        geoJSON.yearBuilt ?? ""
    }
    var yearRehab: String {
        geoJSON.yearRehab ?? ""
    }
    var startNeighborhood: String {
        geoJSON.startNeighborhood ?? ""
    }
    
    var endNeighborhood: String {
        geoJSON.endNeighborhood ?? ""
    }
    
    var neighborhoodRoute: String {
        var route = ""
        if endNeighborhood.count > 0 {
            route += "Locations: " + startNeighborhood
            route += " and " + endNeighborhood
        } else {
            route += "Location: " + startNeighborhood
        }
        return route
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

extension BridgeViewModel {
    #if DEBUG
    static let preview: BridgeViewModel = {
        let geometry =  [MKShape & MKGeoJSONObject]()
        let openDataID: Int = 123456
        let property = GeoJSONProperty(openDataID: openDataID, yearBuilt: "1900", name: "Big Steel Bridge", yearRehab: "2010", imagePath: nil, startNeighborhood: "Downtown", endNeighborhood: "Northside")
        return BridgeViewModel(geometry: geometry, geoJSON: property)
    }()
    #endif
}
