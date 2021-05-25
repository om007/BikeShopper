//
//  DataModels.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/25/21.
//

import MapKit

//Codable struct as target data structure after parsing of JSON reponse from Google Places API search
struct Shop: Identifiable, Decodable {
    var id = UUID()

    var place_id: String?
    var name: String = ""
    var address: String = ""
    var coordinate: CLLocationCoordinate2D?
    var photoRef: String?

    //Nested keys configurations under results item
    //Under 'geometry' key
    enum CodingKeys: String, CodingKey {
        case geometry, name, photos, place_id, vicinity
    }

    enum GeometryCodingKeys: String, CodingKey {
        case location
    }

    enum LocationCodingKeys: String, CodingKey {
        case lat, lng
    }

    //Under 'photos' key
    struct PhotoRef: Codable {
        var photo_reference: String?
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        address = (try? container.decode(String.self, forKey: .vicinity)) ?? ""
        place_id = try? container.decode(String.self, forKey: .place_id)

        //Decoding location coordinates from container
        let geometry = try? container.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)
        let location = try? geometry?.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)

        let lat = try location?.decode(Double.self, forKey: .lat)
        let lng = try location?.decode(Double.self, forKey: .lng)
        if lat != nil  && lng != nil {
            coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        }

        //Deconding photos
        //var photosContainer = try container.nestedUnkeyedContainer(forKey: .photos)
        let photosRefArr = try? container.decode([PhotoRef].self, forKey: .photos)
        photoRef = photosRefArr?.first?.photo_reference
    }
}

struct ShopResponse: Decodable {
    var results: [Shop] = []
    var next_page_token: String?
    var status: String?
}
