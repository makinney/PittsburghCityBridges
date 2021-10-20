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
            let overlays = bridgeModel.overlays()
            if overlays.isEmpty { continue }
            uiView.addOverlays(overlays)
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
    }
    
}


