//
//  Utils.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/25/21.
//

import Foundation

open class Utils {
    
    static func getImageUrl_from(photoRef: String, maxWidth: Int) -> URL? {
        return URL(string: "\(CommonConsts.placePhoto_baseUrl)maxwidth=\(maxWidth)&photoreference=\(photoRef)&key=\(CommonConsts.GoogleAPIKey)")
    }
    
}
