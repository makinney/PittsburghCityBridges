//
//  CityAppModel.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/19/21.
//

import Foundation
import MapKit

struct CityModel {
    static let centerLatitude: Double = 40.44101670487502
    static let centerLongitude: Double = -79.99554306389608
    static let centerLocationCoordiante2D =  CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
    static let regionRadius: CLLocationDistance = 3_000
    static let region = MKCoordinateRegion(center: centerLocationCoordiante2D, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

}
