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
    @ObservedObject var bridgeStore: BridgeStore
    let directionsService = DirectionsService()
    let region: MKCoordinateRegion

    init(region: MKCoordinateRegion, bridgeStore: BridgeStore) {
        self.region = region
        self.bridgeStore = bridgeStore
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
        for bridgeModel in bridgeStore.bridgeModels {
            let overlays = bridgeModel.polylines
            if overlays.isEmpty { continue }
            mapView.addOverlays(overlays)
        }
        mapView.removeAnnotations(mapView.annotations)
        for bridgeModel in bridgeStore.bridgeModels {
            var annotations = [BridgeMapAnnotation]()
            if let coordinate = bridgeModel.locationCoordinate {
                let annotation = BridgeMapAnnotation(coordinate: coordinate, bridgeModel: bridgeModel)
                annotations.append(annotation)
            }
            mapView.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        let mapCoordinator = MapCoordinator(directionsService: directionsService)
        return mapCoordinator
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        let directionsService: DirectionsService
        init(directionsService: DirectionsService) {
            self.directionsService = directionsService
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
            annotationView.canShowCallout = true
            annotationView.titleVisibility = .visible
            annotationView.markerTintColor = .systemGreen
            let buttonImage = UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill") ?? UIImage()
            let directionsRequestButton = UIButton.systemButton(with: buttonImage, target: nil, action: nil) // so we can tap and get the delegate callback
            annotationView.rightCalloutAccessoryView = directionsRequestButton
            let bridgeMapDetailAccessoryView = BridgeMapDetailAccessoryView(bridgeModel: bridgeMapAnnotation.bridgeModel)
            let hostingController = UIHostingController(rootView: bridgeMapDetailAccessoryView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            annotationView.detailCalloutAccessoryView = hostingController.view
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
