//
//  MainView.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/18/21.
//

import SwiftUI
import MapKit

let startingLocation = CLLocationCoordinate2D(latitude: 51.9, longitude: -110.5) //Location to show in HomeView when app starts

struct MainView: View {
    var body: some View {
        TabView {
            HomeView(currentLocation: startingLocation, showingPlaceDetails: true)
                .tabItem { Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            
            ShopsView()
                .tabItem { Label("Shops", systemImage: "list.bullet")
                }
                .tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
