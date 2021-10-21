//
//  LocationManager.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    
    var locationManager = CLLocationManager()
    @Published var locationCoordinate = CLLocationCoordinate2D()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationServices() {
      if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
        locationManager.startUpdatingLocation()
      } else {
        locationManager.requestWhenInUseAuthorization()
      }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
        locationManager.startUpdatingLocation()
      }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationCoordinate = location.coordinate
    }
}
