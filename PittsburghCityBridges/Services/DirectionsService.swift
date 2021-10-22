//
//  DirectionsService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//

import CoreLocation
import Combine
import SwiftUI
import os

class DirectionsService {
    @Environment(\.openURL) private var openURL
    enum DirectionsRequest {
        case no
        case yes
        case fullfilled
    }
    enum UserLocationRequest {
        case none
        case requested
        case requestFullFilled
    }
    private var cancellable: AnyCancellable?
    private var destinationCoordinate = CLLocationCoordinate2D()
    private var directionsRequested = DirectionsRequest.no
    private var userCoordinate = CLLocationCoordinate2D()
    private var userLocationRequest: UserLocationRequest = .none
    private var locationManager: LocationManager
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        locationManager = LocationManager()
        subscribeUserLocation()
    }
    
    func requestDirectionsTo(_ coordinate: CLLocationCoordinate2D) {
        directionsRequested = .yes
        userLocationRequest = .requested
        destinationCoordinate = coordinate
        locationManager.requestUserLocation()
    }
    
    private func subscribeUserLocation() {
        cancellable = locationManager.$userLocationCoordinate
            .sink() { coordinate in
                self.logger.info("received coordinates \(coordinate.latitude)")
                if self.userLocationRequest == .requested {
                    self.userCoordinate =  coordinate
                    self.logger.info("updated user coordinates lat \(coordinate.latitude) and long \(coordinate.longitude)")
                    if self.directionsRequested == .yes {
                        self.requestMapDirections(from: self.userCoordinate, to: self.destinationCoordinate)
                    }
                }
            }
    }
    
    private func requestMapDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let srcLat = from.latitude
        let srcLon = from.longitude
        let dstLat = to.latitude
        let dstLon = to.longitude
        if let url = URL(string: "maps://?saddr=\(srcLat),\(srcLon)&daddr=\(dstLat),\(dstLon)") {
            openURL.callAsFunction(url) { accepted in
                if accepted {
                    self.logger.info("opened URL \(url)")
                } else {
                    self.logger.debug("failed to open URL \(url)")
                }
            }
        }
    }
}
