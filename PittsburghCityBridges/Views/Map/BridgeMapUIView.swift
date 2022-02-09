//
//  MapView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/19/21.
//

import MapKit
import SwiftUI
import os

struct BridgeMapUIView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    let bridgeModels: [BridgeModel]
    private let directionsProvider = DirectionsProvider.shared
    let region: MKCoordinateRegion
    let hasDetailAccessoryView: Bool
    init(region: MKCoordinateRegion,
         bridgeModels: [BridgeModel],
         showsBridgeImage: Bool = true) {
        logger.info("\(#file) \(#function)")
        self.region = region
        self.bridgeModels = bridgeModels
        self.hasDetailAccessoryView = showsBridgeImage
    }
    
    func makeUIView(context: Context) -> MKMapView {
        logger.info("\(#file) \(#function)")
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.isRotateEnabled = false
        if directionsProvider.userlocationAuthorized {
            mapView.showsUserLocation = true
        }
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        logger.info("\(#file) \(#function)")
        mapView.removeOverlays(mapView.overlays)
        for bridgeModel in bridgeModels {
            let overlays = bridgeModel.polylines
            if overlays.isEmpty { continue }
            mapView.addOverlays(overlays)
        }
        mapView.removeAnnotations(mapView.annotations)
        for bridgeModel in bridgeModels {
            var annotations = [BridgeMapAnnotation]()
            if let coordinate = bridgeModel.locationCoordinate {
                let annotation = BridgeMapAnnotation(coordinate: coordinate, bridgeModel: bridgeModel)
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        }
        if bridgeModels.count == 1 {
            if let locationCoordinate = bridgeModels[0].locationCoordinate {
                mapView.centerCoordinate = locationCoordinate
            }
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        let mapCoordinator = MapCoordinator(directionsProvider, hasDetailAccessoryView)
        return mapCoordinator
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        let hasDetailAccessoryView: Bool
        let directionsProvider: DirectionsProvider
        var directionsDisclaimerViewController: UIHostingController<DirectionsDisclaimerView>? = nil
        init(_ directionsProvider: DirectionsProvider,_ hasDetailAccessoryView: Bool) {
            self.directionsProvider = directionsProvider
            self.hasDetailAccessoryView = hasDetailAccessoryView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let lineView = MKPolylineRenderer(overlay: overlay)
                lineView.strokeColor = .systemYellow
                lineView.lineWidth = 6.0
                return lineView
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let location: CLLocation? = userLocation.location
//            let userCoordinates = location?.coordinate
//            if !mapView.isUserLocationVisible {
//                // move map so it's visible, maybe conditionally?
//                // move map to keep user in center of screen ?
//                // or maybe just once, per button toggle
//
//            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let bridgeMapAnnotation = annotation as? BridgeMapAnnotation else {
                return nil
            }
            let reuseIdentifier = "MarkerAnnotationView"
            let annotationView: MKMarkerAnnotationView
            if let markerAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView {
                annotationView = markerAnnotationView
            } else {
                annotationView = MKMarkerAnnotationView(annotation: bridgeMapAnnotation, reuseIdentifier: reuseIdentifier)
            }
            annotationView.markerTintColor = .accentColor
            annotationView.canShowCallout = true
            var buttonImage = UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill") ?? UIImage()
            let buttonImageSize = CGSize(width: 44, height: 44)
            buttonImage = buttonImage.resizeImageTo(size: buttonImageSize)
            buttonImage = buttonImage.withTintColor(.accentColor)
            let directionsRequestButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonImageSize.width, height: buttonImageSize.height))
            directionsRequestButton.setImage(buttonImage, for: .normal)
            annotationView.rightCalloutAccessoryView = directionsRequestButton
            if hasDetailAccessoryView {
                let bridgeMapDetailAccessoryView = BridgeMapDetailAccessoryView(bridgeModel: bridgeMapAnnotation.bridgeModel)
                let hostingController = UIHostingController(rootView: bridgeMapDetailAccessoryView)
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                annotationView.detailCalloutAccessoryView = hostingController.view
            }
            annotationView.layoutIfNeeded()
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let bridgeMapAnnotation = view.annotation as? BridgeMapAnnotation {
                if directionsProvider.userAcceptedDirectionsDisclaimer {
                    directionsProvider.requestDirectionsTo(bridgeMapAnnotation.coordinate)
                    mapView.showsUserLocation = directionsProvider.userlocationAuthorized
                    mapView.deselectAnnotation(view.annotation, animated: true)
                } else {
                    showDirectionsDisclaimerView(mapView: mapView) {
                        if self.directionsProvider.userAcceptedDirectionsDisclaimer {
                            self.directionsProvider.requestDirectionsTo(bridgeMapAnnotation.coordinate)
                            mapView.showsUserLocation = self.directionsProvider.userlocationAuthorized
                            mapView.deselectAnnotation(view.annotation, animated: true)
                        }
                    }
                }
            }
        }
            
        private func showDirectionsDisclaimerView(mapView: MKMapView, done: (() -> Void)?) {
            var directionsDisclaimerView = DirectionsDisclaimerView()
            directionsDisclaimerView.closeTouched = {
                self.directionsDisclaimerViewController?.view?.removeFromSuperview()
                done?()
            }
            directionsDisclaimerViewController = UIHostingController(rootView: directionsDisclaimerView)
            if let view = directionsDisclaimerViewController?.view {
                mapView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
                view.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
                view.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true
            }
        }
    }
}

class BridgeMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var bridgeModel: BridgeModel
    init(coordinate: CLLocationCoordinate2D, bridgeModel: BridgeModel) {
        self.coordinate = coordinate
        self.title = bridgeModel.name
        self.bridgeModel = bridgeModel
        super.init()
    }
}
