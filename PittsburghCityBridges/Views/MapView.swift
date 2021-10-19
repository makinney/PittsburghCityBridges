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
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    typealias UIViewType = MKMapView
    let region: MKCoordinateRegion
    let mapView: MKMapView

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.isRotateEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        logger.info("updateUIView called")
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init()
    }
    
    init(region: MKCoordinateRegion, bridgeModels: [BridgeModel]) {
        mapView = MKMapView()
        self.region = region
        for bridgeModel in bridgeModels {
            let overlays = bridgeModel.overlays()
            if overlays.isEmpty { continue }
            mapView.addOverlays(overlays)
        }
    }
   
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let lineView = MKPolylineRenderer(overlay: overlay)
                lineView.strokeColor = .systemRed
                lineView.lineWidth = 4.0
                return lineView
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
}


