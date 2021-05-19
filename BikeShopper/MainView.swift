//
//  MainView.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit

//Location to show in HomeView when app starts
let startingLocation =
    //CLLocationCoordinate2D(latitude: 27.7056, longitude: 85.2964) //Kathmandu
    CLLocationCoordinate2D(latitude: 40.7831, longitude: 73.9712) //New York
var globalRegion: MKCoordinateRegion!

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
