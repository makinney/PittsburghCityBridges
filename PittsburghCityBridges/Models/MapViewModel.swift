//
//  MapViewModel.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/19/21.
//

import Foundation
import MapKit

struct MapViewModel {
    static let centerLatitude: Double = 40.44101670487502
    static let centerLongitude: Double = -79.99554306389608
    static let centerLocationCoordiante2D =  CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
    static let singleBridgeRegionRadius: CLLocationDistance = 100
    static let singleBridgeRegion = MKCoordinateRegion(center: centerLocationCoordiante2D, latitudinalMeters: singleBridgeRegionRadius, longitudinalMeters: singleBridgeRegionRadius)
    
    var multipleBridgesRegionRadius: CLLocationDistance {
        let regionRadius: CLLocationDistance
        if UIDevice.current.userInterfaceIdiom == .phone {
                regionRadius = 5_000
            } else {
                regionRadius = 12_500
            }
        return regionRadius
    }
    
    var multipleBridgesRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: MapViewModel.centerLocationCoordiante2D,
                                  latitudinalMeters: multipleBridgesRegionRadius,
                                  longitudinalMeters: multipleBridgesRegionRadius)
        
    }
}
