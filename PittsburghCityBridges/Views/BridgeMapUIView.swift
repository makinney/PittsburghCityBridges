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
    @ObservedObject var locationManager = LocationManager()
    let region: MKCoordinateRegion        
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
        return MapCoordinator()
    }
    
    init(region: MKCoordinateRegion, bridgeStore: BridgeStore) {
        self.region = region
        self.bridgeStore = bridgeStore
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let lineView = MKPolylineRenderer(overlay: overlay)
                lineView.strokeColor = .systemRed
                lineView.lineWidth = 6.0
                return lineView
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let bridgeMapAnnotation = annotation as? BridgeMapAnnotation else {
              return nil
            }
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MarkerAnnotationView") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: bridgeMapAnnotation, reuseIdentifier: "MarkerAnnotationView")
            annotationView.canShowCallout = true
            annotationView.titleVisibility = .visible
            let detailView = BridgeMapDetailAccessoryView(bridgeModel: bridgeMapAnnotation.bridgeModel)
            let vc = UIHostingController(rootView: detailView)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            annotationView.detailCalloutAccessoryView = vc.view
            return annotationView
        }
    }
    
}

class BridgeMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var bridgeModel: BridgeModel
    init(coordinate: CLLocationCoordinate2D, bridgeModel: BridgeModel) {//, locationManager: LocationManager) {
        self.coordinate = coordinate
        self.title = bridgeModel.name
        self.bridgeModel = bridgeModel
        super.init()
    }
}

class DirectionsRequested: NSObject, ObservableObject {
    @Published var requested = false
    
    func requestDirections() {
        requested = true
    }
    
    override init() {
        super.init()
    }
}
