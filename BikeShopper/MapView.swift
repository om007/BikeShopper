//
//  LocationManager.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    var locationManager = CLLocationManager()
    var annotations: [MKPointAnnotation]
    
    let radius: CLLocationDistance = 160934 //100 miles value in metres
    
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
        if let currentLocation = self.currentLocation {
            if let annotation = self.selectedPlace {
                view.removeAnnotation(annotation)
            }
            view.showsUserLocation = true
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: radius, longitudinalMeters: radius)
            view.setRegion(region, animated: true)
            
            //TO-DO
            globalRegion = region

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
                parent.currentLocation = userLocation.coordinate
                centerLocationOnce = false
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
