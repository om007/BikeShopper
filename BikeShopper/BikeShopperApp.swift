//
//  BikeShopperApp.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import GooglePlaces

@main
struct BikeShopperApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate    {
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSPlacesClient.provideAPIKey(CommonConsts.GoogleAPIKey)
        return true
     }
}
