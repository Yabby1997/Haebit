//
//  MapPicker.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import MapKit
import HaebitCommonModels

@MainActor
struct MapPicker: View {
    @Binding var coordinate: Coordinate?
    
    var body: some View {
        MapViewRepresentable(coordinate: $coordinate)
    }
}

@MainActor
struct MapViewRepresentable: UIViewRepresentable {
    @Binding var coordinate: Coordinate?
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.updateCoordinate(coordinate)
    }
    
    func makeUIView(context: Context) -> some UIView {
        context.coordinator.mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coordinate: $coordinate)
    }
    
    @MainActor
    class Coordinator: NSObject, MKMapViewDelegate {
        let mapView = MKMapView()
        
        @Binding var coordinate: Coordinate?
        private var span: MKCoordinateSpan?
        
        init(coordinate: Binding<Coordinate?>) {
            _coordinate = coordinate
            super.init()
            setup()
        }
        
        private func setup() {
            mapView.delegate = self
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(didTap))
            mapView.addGestureRecognizer(gesture)
        }
        
        func updateCoordinate(_ coordinate: Coordinate?) {
            guard let coordinate else {
                mapView.removeAnnotations(mapView.annotations)
                return
            }
            
            guard mapView.annotations.first?.coordinate.coordinate != coordinate else { return }
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = coordinate.clLocationCoordinate2D
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(newAnnotation)
            
            if let span {
                mapView.setRegion(
                    .init(
                        center: coordinate.clLocationCoordinate2D,
                        span: span
                    ),
                    animated: true
                )
            } else {
                mapView.setRegion(
                    .init(
                        center: coordinate.clLocationCoordinate2D,
                        latitudinalMeters: 1_000,
                        longitudinalMeters: 1_000
                    ),
                    animated: true
                )
            }
        }
        
        @objc private func didTap(_ sender: UITapGestureRecognizer) {
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            coordinate = touchCoordinate.coordinate
            span = mapView.region.span
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
        }
    }
}
