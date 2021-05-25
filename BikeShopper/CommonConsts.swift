//
//  CommonConsts.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 20/05/2021.
//

import Foundation
import MapKit

struct CommonConsts {
    
    static let placeholder = "photo.fill"
    static let radius: CLLocationDistance = 100 * 1609.34 //100 miles value in metres
    static let initialLocation = //CLLocationCoordinate2D(latitude: 27.7056, longitude: 85.2964) //Kathmandu
        CLLocationCoordinate2D(latitude: 40.7831, longitude: 73.9712) //New York
    
    //Google Places API related
    static let GoogleAPIKey = "AIzaSyC4fRc6ZhOe8Yn36cLezxsehDMCWtqPuys"

    static let nearbySearch_baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    static let placePhoto_baseUrl = "https://maps.googleapis.com/maps/api/place/photo?"
    
    static let FINISHED = "FINISHED"
}
