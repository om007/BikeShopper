//
//  ShopDetail.swift
//  BikeShopper
//
//  Created by Nikesh Jha on 5/19/21.
//

import SwiftUI
import MapKit

struct ShopDetailView: View {
    let shop: Shop
    @State var shopRegion = MKCoordinateRegion()
    
    var body: some View {
        VStack {
            shopImage
                .frame(width: 120, height: 120, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 4)
                )
                .shadow(radius: 10)
            
            Text(shop.name)
                .font(.title)
            
            Divider()
            
            Text(shop.address)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationBarTitle(Text(shop.name), displayMode: .inline)
        
        //Showing Map as well without any padding unlike in the views above
        Map(coordinateRegion: $shopRegion, annotationItems: [shop]) {
            MapMarker(coordinate: $0.coordinate!, tint: .green)
        }
        .onAppear(perform: {
            shopRegion = MKCoordinateRegion(
                center: shop.coordinate!,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        })
    }
    
    @ViewBuilder var shopImage: some View {
        if let imageUrl = Utils.getImageUrl_from(photoRef: shop.photoRef ?? "", maxWidth: 400) {
            AsyncImage(url: imageUrl, placeholder: { ProgressView() }, image: { Image(uiImage: $0).resizable() })
        } else {
            Image(systemName: CommonConsts.placeholder)
        }
    }
}
