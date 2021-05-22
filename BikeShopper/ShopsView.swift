//
//  Shops.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/18/21.
//

import SwiftUI
import MapKit

struct ShopsView: View {
    
    @EnvironmentObject var currentPosition: Position
    @State var allShops: [Shop] = []
    
    var body: some View {
        NavigationView {
            List(allShops) { shop in
                ShopCell(shop: shop)
            }
            .navigationBarTitle("Bike Shops", displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle()) //Since our UI should look the same in all form factors
        .onAppear(perform: { getNearbyBikeShops() })
    }
    
    func getNearbyBikeShops() {
        var allShops: [Shop] = []
        
        //Creating a search request object with updated map region object and the keyword "Bike shops"
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Bike shops"
        request.region = currentPosition.region
        
        //Searching for the bike shops that falls within the secified region that is set to the seach request object
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, error) in
            guard let response = response else { return }
            
            for item in response.mapItems {
                let thumbnail = UIImage(systemName: "heart.fill")! //item.thumbnail
                let name = item.name ?? ""
                let addressArr = [item.placemark.thoroughfare, item.placemark.locality, item.placemark.subLocality, item.placemark.country]
                let coordinate = item.placemark.coordinate
                let shopObj = Shop(thumbnail: thumbnail, locationName: name, address: addressArr.compactMap({ $0 }).joined(separator: ", "), coordinate: coordinate)
                allShops.append(shopObj)
            }
            
//            //TO-REMOVE: Creating duplicate data
//            for _ in 0..<10 {
//                allShops += allShops
//            }
            
            self.allShops = allShops
        })
        
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        ShopsView()
    }
}

//Custom Cell for displaying Shop info in list View
struct ShopCell: View {
    let shop: Shop
    
    var body: some View {
        NavigationLink(destination: ShopDetailView(shop: shop)) {
            Image(uiImage: shop.thumbnail!)
            VStack(alignment: .leading) {
                Text(shop.locationName)
                    .font(.headline)
                Text(shop.address)
                    .font(.subheadline)
            }
        }
    }
}

//Model class for Shop
class Shop: Identifiable {
    var thumbnail: UIImage?
    var locationName: String = "Location"
    var address: String = "Address"
    var coordinate: CLLocationCoordinate2D?
    
    init(thumbnail: UIImage, locationName: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.thumbnail = thumbnail
        self.locationName = locationName
        self.address = address
        self.coordinate = coordinate
    }
    
}
