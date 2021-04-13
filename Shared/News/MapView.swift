//
//  MapView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import SwiftUI
import MapKit

struct MapView: View {
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3382, longitude: 121.8863), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//
    @ObservedObject var mapmodel: MapModel

    
    var body: some View {
        
        //
        //Map(coordinateRegion: $mapmodel.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
        Map(coordinateRegion: $mapmodel.region, annotationItems: mapmodel.points) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
            //.edgesIgnoringSafeArea(.all)
                    //.frame(width: 400, height: 300)
    }
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView(mapmodel: MapModel(coordinate: Coordinate(latitude: 40.75773, longitude: -73.985708)))
//        MapView(mapmodel: MapModel(coordinate: Coordinate(latitude: 37.335480, longitude: -121.893028)))
    }
}
