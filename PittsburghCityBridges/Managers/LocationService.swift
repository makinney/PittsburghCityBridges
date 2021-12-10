//
//  LocationService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//

import CoreLocation
import os

final class LocationService: NSObject, ObservableObject {    
    enum UserLocationRequest {
        case none
        case requested
        case requestFullFilled
    }
    
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    var locationManager = CLLocationManager()
    @Published var locationCoordinate = CLLocationCoordinate2D()
    @Published var userLocationCoordinate = CLLocationCoordinate2D()
    private var userLocationRequest: UserLocationRequest = .none
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
    }
    
    func requestUserLocation() {
        userLocationRequest = .requested
        // way to check state?
        startLocationServices()
    }
    
    func startLocationServices() {
      if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
        locationManager.startUpdatingLocation()
      } else {
        locationManager.requestWhenInUseAuthorization()
      }
    }
    
    private func requestOneLocationUpdate() {
      if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
          locationManager.requestLocation()
      } else {
        locationManager.requestWhenInUseAuthorization()
      }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
          requestOneLocationUpdate()
      }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationCoordinate = location.coordinate
        if userLocationRequest == .requested {
            userLocationCoordinate = location.coordinate
            userLocationRequest = .requestFullFilled
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.debug("LocationManager \(error.localizedDescription)")
    }
}
