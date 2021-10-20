//
//  MapView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/19/21.
//

import MapKit
import SwiftUI
import os

struct MapView: UIViewRepresentable {
    @ObservedObject var bridgeStore: BridgeStore
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    typealias UIViewType = MKMapView
    let region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.isRotateEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        logger.info("updateUIView called")
        for bridgeModel in bridgeStore.bridgeModels {
            let overlays = bridgeModel.polylines
            if overlays.isEmpty { continue }
            uiView.addOverlays(overlays)
        }
        uiView.removeAnnotations(uiView.annotations)
        for bridgeModel in bridgeStore.bridgeModels {
            var annotations = [BridgeMapAnnotation]()
            if let coordinate = bridgeModel.locationCoordinate {
                let annotation = BridgeMapAnnotation(coordinate: coordinate, bridgeModel: bridgeModel)
                annotations.append(annotation)
            }
            uiView.addAnnotations(annotations)
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

            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BridgeLocation") as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: bridgeMapAnnotation, reuseIdentifier: "BridgeLocation")
 //           annotationView.canShowCallout = true
            annotationView.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            annotationView.titleVisibility = .visible
//            annotationView.detailCalloutAccessoryView = UIImage(named: placeAnnotation.image).map(UIImageView.init)
            return annotationView
        }
    }
    
}

class BridgeMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, bridgeModel: BridgeModel) {
        self.coordinate = coordinate
        self.title = bridgeModel.name
        self.subtitle = bridgeModel.startNeighborhood
    }
}
