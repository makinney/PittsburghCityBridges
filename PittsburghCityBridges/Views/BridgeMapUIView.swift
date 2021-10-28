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
    let directionsService = DirectionsService()
    let region: MKCoordinateRegion
    let hasDetailAccessoryView: Bool
    
    init(region: MKCoordinateRegion, bridgeModels: [BridgeModel], hasDetailAccessoryView: Bool = true) {
        self.region = region
        self.bridgeModels = bridgeModels
        self.hasDetailAccessoryView = hasDetailAccessoryView
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.isRotateEnabled = false
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        logger.info("updateUIView called")
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
        let mapCoordinator = MapCoordinator(directionsService, hasDetailAccessoryView)
        return mapCoordinator
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        let hasDetailAccessoryView: Bool
        let directionsService: DirectionsService
        init(_ directionsService: DirectionsService, _ hasDetailAccessoryView: Bool) {
            self.directionsService = directionsService
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
            annotationView.markerTintColor = .systemGreen
            annotationView.canShowCallout = true
            let buttonImage = UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill") ?? UIImage()
            let directionsRequestButton = UIButton.systemButton(with: buttonImage, target: nil, action: nil) // so we can tap and get the delegate callback
            annotationView.rightCalloutAccessoryView = directionsRequestButton
            if hasDetailAccessoryView {
                let bridgeMapDetailAccessoryView = BridgeMapDetailAccessoryView(bridgeModel: bridgeMapAnnotation.bridgeModel)
                let hostingController = UIHostingController(rootView: bridgeMapDetailAccessoryView)
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                annotationView.detailCalloutAccessoryView = hostingController.view
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let bridgeMapAnnotation = view.annotation as? BridgeMapAnnotation {
                directionsService.requestDirectionsTo(bridgeMapAnnotation.coordinate)
                mapView.deselectAnnotation(view.annotation, animated: true)
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
