//
//  MainView.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit


struct MainView: View {
    
    var currentPosition = Position()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(1)
            
            ShopsView()
                .tabItem {
                    Label("Shops", systemImage: "list.bullet")
                }
                .tag(2)
        }.environmentObject(currentPosition)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//User's position detail object meant to be shared across all the tabs
class Position: ObservableObject {
    //Location to show in HomeView when app starts
    @Published var coordinate: CLLocationCoordinate2D!
    @Published var region: MKCoordinateRegion!
        
    init() {
        let initialLocation = //CLLocationCoordinate2D(latitude: 27.7056, longitude: 85.2964) //Kathmandu
            CLLocationCoordinate2D(latitude: 40.7831, longitude: 73.9712) //New York
        coordinate = initialLocation
        region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: CommonConsts.radius, longitudinalMeters: CommonConsts.radius)
    }
}
