//
//  Shops.swift
//  BikeShopper
//
//  Created by Om Prakash Shah on 5/18/21.
//

import SwiftUI
import MapKit
import Foundation

struct ShopsView: View {
    
    @EnvironmentObject var currentPosition: Position
    @State private var response = ShopResponse()
    @State private var isLoading = false
    @State private var isLoadingFirstTime = true //Boolean to check view is loaded the first time
    
    var body: some View {
        NavigationView {
            List {
                if response.results.isEmpty && !isLoadingFirstTime {
                    //If results is empty
                    Text("Oops! Failed to retrive bike shops near 100 miles radius.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                } else {
                    ForEach(response.results) { shop in
                        ShopCell(shop: shop)
                            .onAppear(perform: {
                                loadMoreContentIfNeeded(item: shop)
                            })
                    }
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("Bike Shops", displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle()) //Since our UI should look the same in all form factors
        .onAppear(perform: { getNearbyBikeShops() })
    }
    
    func getNearbyBikeShops() {
        guard response.status != CommonConsts.FINISHED else {
            //If response status has 'FINISHED' value, it means all the data has been fetched and loaded
            return
        }
        
        //Creating a search request object with updated map region object and the keyword "Bike shops"
        let latitude = String(format: "%f", currentPosition.coordinate.latitude)
        let longitude = String(format: "%f", currentPosition.coordinate.longitude)
        let radius = String(format: "%.0f", CommonConsts.radius)
        let type = "bicycle_store"

        var urlString = ""
        if let token = response.next_page_token {
            //Creating url with 'next_page_token' if its value was present in the last search response, since it will execute a search with a same paramenters used previously.
            //Note for Google Maps Platform Premium Plan customers: You must include an API key in your requests. You should not include a client or signature parameter with your requests.
            urlString = "\(CommonConsts.nearbySearch_baseURL)pagetoken=\(token)&key=\(CommonConsts.GoogleAPIKey)"
        } else {
            urlString = "\(CommonConsts.nearbySearch_baseURL)location=\(latitude),\(longitude)&radius=\(radius)&type=\(type)&key=\(CommonConsts.GoogleAPIKey)"
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode(ShopResponse.self, from: data)
                    DispatchQueue.main.async {
                        let newShops = decodedResponse.results
                        self.response.results += newShops
                        self.response.next_page_token = decodedResponse.next_page_token
                        self.response.status = decodedResponse.status
                        
                        if decodedResponse.next_page_token == nil {
                            //If there is no more data available to fectch then update FINISHED status
                            self.response.status = CommonConsts.FINISHED
                        }
                    }
                    
                    self.isLoadingFirstTime = false
                    return
                } catch {
                    print(error)
                }
            }

            //If any one event among response data or decoding fails
            print("Fetch failed: \(error?.localizedDescription ?? " Unknown error!")")
            self.isLoadingFirstTime = false
        }
        task.resume()
    }
    
    func loadMoreContentIfNeeded(item: Shop) {
        //Load more bike shops if the current item falls around the last 2 index items
        let allShops = response.results
        let thresoldIndex = allShops.index(allShops.endIndex, offsetBy: -2)
        if allShops.firstIndex(where: { $0.id == item.id }) == thresoldIndex {
            getNearbyBikeShops()
        }
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
            if let imageUrl = Utils.getImageUrl_from(photoRef: shop.photoRef ?? "", maxWidth: 100) {
                AsyncImage(url: imageUrl, placeholder: { Image(systemName: CommonConsts.placeholder) }, image: { Image(uiImage: $0).resizable() })
                    .frame(width: 50, height: 50, alignment: .center)
                    .aspectRatio(contentMode: .fill)
            }
            
            VStack(alignment: .leading) {
                Text(shop.name)
                    .font(.headline)
                Text(shop.address)
                    .font(.subheadline)
            }
        }
    }
}
