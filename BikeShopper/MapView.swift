//
//  LocationManager.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var currentPosition: Position

    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    var locationManager = CLLocationManager()
    var annotations: [MKPointAnnotation]
        
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //When you need a precise location, However, the app should be authorized to access precise location i.e. isAuthorizedForPreciseLocation should be true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        //mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if let currentRegion = currentPosition.region {
            if let annotation = self.selectedPlace {
                view.removeAnnotation(annotation)
            }
            view.showsUserLocation = true
            view.setRegion(currentRegion, animated: true)
        } else if let annotation = self.selectedPlace {
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(parent: self)
    }
    
    //A custom coordinator made to communicate changes to MapView when values are changed by the delegate methods within
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        var centerLocationOnce = true
        let identifier = "PlaceMark"
        
        init(parent: MapView) {
            self.parent = parent
        }
        
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            if !mapView.showsUserLocation {
//                parent.currentLocation = mapView.centerCoordinate
//            }
//        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if centerLocationOnce {
                //Update the environment user's current position object
                let newCoordinate = userLocation.coordinate
                parent.currentPosition.coordinate = newCoordinate
                parent.currentPosition.region = MKCoordinateRegion(center: newCoordinate, latitudinalMeters: CommonConsts.radius, longitudinalMeters: CommonConsts.radius)
                
                centerLocationOnce = false
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var annotationMarker = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationMarker == nil {
                annotationMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationMarker?.canShowCallout = true
                //annotationMarker?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationMarker?.annotation = annotation
            }
            
            return annotationMarker
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let place = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = place
            parent.showingPlaceDetails = true
        }
    }
}
