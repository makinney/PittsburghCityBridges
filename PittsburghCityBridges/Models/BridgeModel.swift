//
//  BridgeModel.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/14/21.
//

import MapKit

struct BridgeModel: Identifiable {
    var id: Int {
        openDataID
    }
    var openDataID: Int {
        geoJSON.openDataID
    }
    var name: String {
        guard let name = geoJSON.name,
              !name.isEmpty else {
                  return ""
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
                  return "?"
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
    
    var geometry: [MKShape & MKGeoJSONObject]
    var geoJSON: GeoJSONProperty
    var locationCoordinate: CLLocationCoordinate2D? {
        return polylines.first?.coordinates.first
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
}

// MARK: View Model Like
//
extension BridgeModel {
    func builtHistory() -> String {
        var history = ""
        if !yearBuilt.isEmpty {
            history = "Year Built: \(yearBuilt) "
        }
        if !yearRehab.isEmpty {
            history += "\nRehabbed: \(yearRehab)"
        }
        return history
    }
    
    func neighborhoods() -> String {
        var description = "Neighborhood: \(startNeighborhood)"
        if let endNeighborhood = endNeighborhood {
            description += " and runs to \(endNeighborhood)"
        }
        return description
    }

    func refurbished() -> String {
        var description = ""
        if !yearRehab.isEmpty {
            description = "\(yearRehab)"
        }
        return description
    }
}

// MARK: SwiftUI Preview Support
//
extension BridgeModel {
    static let preview: BridgeModel = {
        let openDataID: Int = 123456
        let imagePath = "https://tools.wprdc.org/images/pittsburgh/bridges/Charles_Anderson_Bridge.jpg"
        let property = GeoJSONProperty(openDataID: openDataID, yearBuilt: "1989", name: "Charles Anderson Bridge", yearRehab: "1987", imagePath: imagePath, startNeighborhood: "Squirrel Hill South", endNeighborhood: "South Oakland")
        var geometry =  [MKShape & MKGeoJSONObject]()
        let startPoint = CLLocationCoordinate2D(latitude: 40.43423858438876, longitude: -79.95168694309808)
        let endPoint = CLLocationCoordinate2D(latitude: 40.43458973277687, longitude: -79.94857558064106)
        var polyCoordinates = [CLLocationCoordinate2D]()
        polyCoordinates.append(startPoint)
        polyCoordinates.append(endPoint)
        let polyline: MKPolyline = MKPolyline(coordinates: polyCoordinates)
        geometry.append(polyline)
        return BridgeModel(geometry: geometry, geoJSON: property)
    }()
}
