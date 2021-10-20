//
//  BridgeModel.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/14/21.
//

import Foundation
import MapKit

extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

struct BridgeModel: Identifiable {
    var id: Int {
        geoJSON.openDataID
    }
    var geometry: [MKShape & MKGeoJSONObject]
    var geoJSON: GeoJSONProperty
    var locationCoordinate: CLLocationCoordinate2D? {
        return polylines.first?.coordinates.first
    }
    var openDataID: Int {
        geoJSON.openDataID
    }
    var polylines: [MKPolyline] {
        var lines = [MKPolyline]()
        for geo in geometry {
            if let polyline = geo as? MKPolyline {
                lines.append(polyline)
            }
        }
        return lines
    }
    var name: String {
        guard let name = geoJSON.name,
              !name.isEmpty else {
                  return "no name provided"
              }
        return name
    }
    var imageURL: URL? {
        if let imagePath = geoJSON.imagePath {
            return URL(string: imagePath)
        }
        return nil
    }
    var yearBuilt: String {
        guard let yearBuilt = geoJSON.yearBuilt,
              !yearBuilt.isEmpty else {
                  return ""
              }
        return yearBuilt
        
    }
    var yearRehab: String {
        guard let yearRehab = geoJSON.yearRehab,
              !yearRehab.isEmpty else {
                  return ""
              }
        return yearRehab
    }
    var startNeighborhood: String {
        guard let startNeighborhood = geoJSON.startNeighborhood,
              !startNeighborhood.isEmpty else {
                  return "Pittsburgh"
              }
        return startNeighborhood
    }
    var endNeighborhood: String? {
        guard let endNeighborhood = geoJSON.endNeighborhood,
              !endNeighborhood.isEmpty else {
                  return nil
              }
        return endNeighborhood
    }
    
    func description() -> String {
        var desc = "The \(name)"
        desc += " is located in the \(startNeighborhood) neighborhood"
        if let endLocation = endNeighborhood {
            desc += " and in the \(endLocation) neighborhood"
        }
        desc += "."
        desc += " It was built in \(yearBuilt)."
        if !yearRehab.isEmpty {
            desc += " It was reburbished in \(yearRehab)."
        }
        return desc
    }
}

extension BridgeModel {
    #if DEBUG
    static let preview: BridgeModel = {
        let geometry =  [MKShape & MKGeoJSONObject]()
        let openDataID: Int = 123456
        let imagePath = "https://tools.wprdc.org/images/pittsburgh/bridges/Hot_Metal_Pedestrian_Bridge.jpg"
        let property = GeoJSONProperty(openDataID: openDataID, yearBuilt: "1900", name: "Hot Metal Bridge", yearRehab: "2010", imagePath: imagePath, startNeighborhood: "Downtown", endNeighborhood: "Northside")
        return BridgeModel(geometry: geometry, geoJSON: property)
    }()
    #endif
}
