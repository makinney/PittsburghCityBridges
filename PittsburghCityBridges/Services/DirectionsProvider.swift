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
    @AppStorage("selected.navigation.app") private var selectedMappingApp = MappingApp.apple

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
    
    enum MappingApp: String {
        case apple = "Apple Maps"
        case google = "Google Maps"
        case waze = "Waze"
    }

    private var cancellable: AnyCancellable?
    private var destinationCoordinate = CLLocationCoordinate2D()
    private var directionsRequested = DirectionsRequest.no
    private var userCoordinate = CLLocationCoordinate2D()
    private var userLocationRequest: UserLocationRequest = .none
    private var locationService: LocationService
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    private (set)var supportedMappingApps = Set<MappingApp>()
    var userlocationAuthorized: Bool {
        if locationService.userAuthorizationStatus == .authorizedAlways || locationService.userAuthorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    private init() {
        locationService = LocationService()
        determineSupportedMappingApps()
        subscribeUserCoordinatesUpdates()
    }
    
    func requestDirectionsTo(_ coordinate: CLLocationCoordinate2D) {
        directionsRequested = .yes
        userLocationRequest = .requested
        destinationCoordinate = coordinate
        locationService.requestUserLocation()
    }
    
    func select(mappingApp: MappingApp) {
        if supportedMappingApps.contains(mappingApp) {
            selectedMappingApp = mappingApp
        } else {
            self.logger.info("\(#file) \(#function) not supported selected map \(mappingApp.rawValue)")
        }
    }
    
    private func determineSupportedMappingApps() {
        if canOpenAppleMaps() {
            supportedMappingApps.insert(.apple)
        }
        if canOpenGoogleMaps() {
            supportedMappingApps.insert(.google)
        }
        if canOpenWaze() {
            supportedMappingApps.insert(.waze)
        }
    }
    
    private func subscribeUserCoordinatesUpdates() {
        cancellable = locationService.$userLocationCoordinate
            .sink() { [weak self] coordinate in
                guard let self = self else { return }
                if self.userLocationRequest == .requested {
                    self.userCoordinate =  coordinate
                    self.logger.info("\(#file) \(#function) updated user coordinates lat \(coordinate.latitude) and long \(coordinate.longitude)")
                    if self.directionsRequested == .yes {
                        switch self.selectedMappingApp {
                        case .apple:
                            self.requestAppleMapDirections(from: self.userCoordinate, to: self.destinationCoordinate)
                        case .google:
                            self.requestGoogleMapDirections(from: self.userCoordinate, to: self.destinationCoordinate)
                        case .waze:
                            self.requestWazeMapDirections(from: self.userCoordinate, to: self.destinationCoordinate)
                        }
                    }
                }
            }
    }
    
    private func canOpenAppleMaps() -> Bool {
       return UIApplication.shared.canOpenURL(URL(string:"maps://")!)
    }
    
    private func canOpenGoogleMaps() -> Bool {
       return UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)
    }
    
    private func canOpenWaze() -> Bool {
       return UIApplication.shared.canOpenURL(URL(string:"waze://")!)
    }

    private func requestAppleMapDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
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
    
    private func requestGoogleMapDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let srcLat = from.latitude
        let srcLon = from.longitude
        let dstLat = to.latitude
        let dstLon = to.longitude
        if let url = URL(string: "comgooglemaps://?saddr=\(srcLat),\(srcLon)&daddr=\(dstLat),\(dstLon)") {
            openURL.callAsFunction(url) { accepted in
                if accepted {
                    self.logger.info("\(#file) \(#function) opened URL \(url)")
                } else {
                    self.logger.debug("\(#file) \(#function) failed to open URL \(url)")
                }
            }
        }
    }
    
    private func requestWazeMapDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let dstLat = to.latitude
        let dstLon = to.longitude
        if let url = URL(string: "https://www.waze.com/ul?ll=\(dstLat)%2C\(dstLon)&navigate=yes") {
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
