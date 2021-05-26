//
//  MainView.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit


struct MainView: View {
    
    private var currentPosition = Position()
    
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
        let initialLoc = CommonConsts.initialLocation
        coordinate = initialLoc
        region = MKCoordinateRegion(center: initialLoc, latitudinalMeters: CommonConsts.radius, longitudinalMeters: CommonConsts.radius)
    }
}
