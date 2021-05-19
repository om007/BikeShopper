//
//  HomeView.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @State var currentLocation: CLLocationCoordinate2D?
    @State var selectedPlace: MKPointAnnotation?
    @State var showingPlaceDetails: Bool
    
    var locations: [MKPointAnnotation] = []
    
    var body: some View {
        ZStack {
            MapView(currentLocation: $currentLocation, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
            
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        getCurrentLocation()
//                    }){
//                        Image(systemName: "location.circle.fill")
//                            .padding()
//                            .background(Color.blue.opacity(0.7))
//                            .foregroundColor(.white)
//                            .font(.system(.headline))
//                            .clipShape(Circle())
//                            .rotationEffect(.degrees(45))
//                    }
//                }
//                .padding()
//            }
        }
        .onAppear(perform: {
            
        })
    }
    
//    func getCurrentLocation() {
//        self.currentLocation = locationManager.lastLocation ?? startingLocation
//    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentLocation: startingLocation, showingPlaceDetails: true)
    }
}


