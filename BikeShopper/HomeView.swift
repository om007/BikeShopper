//
//  HomeView.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/18/21.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @State var centerCoordinate = CLLocationCoordinate2D()
    @State var currentLocation: CLLocationCoordinate2D?
    @State var selectedPlace: MKPointAnnotation?
    @State var showingPlaceDetails: Bool
    
    var locations: [MKPointAnnotation] = []
    var locationManager = LocationManager()
    
//    @State private var userTrackingMode: MapUserTrackingMode = .follow
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 25.4,
//            longitude: 80
//        ),
//        span: MKCoordinateSpan(
//            latitudeDelta: 50,
//            longitudeDelta: 50)
//        )
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, currentLocation: $currentLocation, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        getCurrentLocation()
                    }){
                        Image(systemName: "location.circle.fill")
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .font(.system(.headline))
                            .clipShape(Circle())
                            .rotationEffect(.degrees(45))
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: {
            locationManager.start()
        })
    }
    
    func getCurrentLocation() {
        self.currentLocation = locationManager.lastLocation ?? startingLocation
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentLocation: startingLocation, showingPlaceDetails: true)
    }
}


