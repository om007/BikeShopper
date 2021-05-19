//
//  ShopDetail.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/19/21.
//

import SwiftUI

struct ShopDetailView: View {
    let shop: Shop
    
    var body: some View {
        VStack {
            Image(uiImage: shop.thumbnail!)
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 4)
                )
                .shadow(radius: 10)
            Text(shop.locationName)
                .font(.title)
            
            Divider()
            
            Text(shop.address)
                .font(.subheadline)
                .foregroundColor(.gray)
        }.padding().navigationBarTitle(Text(shop.locationName), displayMode: .inline)
    }
}

struct ShopDetail_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailView(shop: Shop(thumbnail: UIImage(systemName: "house.fill")!, locationName: "NY Bike Shop", address: "Manhattan, New York"))
    }
}