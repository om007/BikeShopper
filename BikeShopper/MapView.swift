//
//  LocationManager.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/18/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    var annotations: [MKPointAnnotation]
    
    let radius: CLLocationDistance = 160934 //100 miles value in metres
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if let currentLocation = self.currentLocation {
            if let annotation = self.selectedPlace {
                view.removeAnnotation(annotation)
            }
            view.showsUserLocation = true
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: radius, longitudinalMeters: radius)
            view.setRegion(region, animated: true)
        } else if let annotation = self.selectedPlace {
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        let identifier = "PlaceMark"
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if !mapView.showsUserLocation {
                parent.centerCoordinate = mapView.centerCoordinate
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var annotationPin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationPin == nil {
                annotationPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationPin?.canShowCallout = true
                annotationPin?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationPin?.annotation = annotation
            }
            
            return annotationPin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let place = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = place
            parent.showingPlaceDetails = true
        }
    }
    
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first?.coordinate
    }
}
