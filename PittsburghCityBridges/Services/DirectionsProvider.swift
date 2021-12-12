//
//  DirectionsProvider.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/21/21.
//

import CoreLocation
import Combine
import SwiftUI
import os

class DirectionsProvider {
    @Environment(\.openURL) private var openURL
    static let shared = DirectionsProvider()
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
    private var locationService: LocationService
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    var userlocationAuthorized: Bool {
        if locationService.userAuthorizationStatus == .authorizedAlways || locationService.userAuthorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    private init() {
        locationService = LocationService()
        subscribeUserCoordinatesUpdates()
    }
    
    func requestDirectionsTo(_ coordinate: CLLocationCoordinate2D) {
        directionsRequested = .yes
        userLocationRequest = .requested
        destinationCoordinate = coordinate
        locationService.requestUserLocation()
    }
    
    private func subscribeUserCoordinatesUpdates() {
        cancellable = locationService.$userLocationCoordinate
            .sink() { coordinate in
                self.logger.info("\(#file) \(#function) received coordinates \(coordinate.latitude)")
                if self.userLocationRequest == .requested {
                    self.userCoordinate =  coordinate
                    self.logger.info("\(#file) \(#function) updated user coordinates lat \(coordinate.latitude) and long \(coordinate.longitude)")
                    if self.directionsRequested == .yes {
                        self.requestMapDirections(from: self.userCoordinate, to: self.destinationCoordinate)
                    }
                }
            }
    }
    
    private func requestMapDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        // opens Apple Maps
        let srcLat = from.latitude
        let srcLon = from.longitude
        let dstLat = to.latitude
        let dstLon = to.longitude
        if let url = URL(string: "maps://?saddr=\(srcLat),\(srcLon)&daddr=\(dstLat),\(dstLon)") {
            openURL.callAsFunction(url) { accepted in
                if accepted {
                    self.logger.info("\(#file) \(#function) opened URL \(url)")
                } else {
                    self.logger.debug("\(#file) \(#function) failed to open URL \(url)")
                }
            }
        }
    }
}
