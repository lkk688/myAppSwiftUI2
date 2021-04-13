//
//  MapModel.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import Foundation

import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

class MapModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var points: [AnnotatedItem] = []
    
    var currentlocation: Bool = false
    
    static var pointsOfInterest = [
        AnnotatedItem(name: "Times Square", coordinate: .init(latitude: 40.75773, longitude: -73.985708)),
        AnnotatedItem(name: "Flatiron Building", coordinate: .init(latitude: 40.741112, longitude: -73.989723)),
        AnnotatedItem(name: "Empire State Building", coordinate: .init(latitude: 40.748817, longitude: -73.985428))
        ]
    
    init(name: String? = "", coordinate: Coordinate? = testcoordinate) {
        let regioncoordinate = coordinate ?? MapModel.testcoordinate //Coordinate(latitude: coordinate?.latitude ?? 48.687330584, longitude: coordinate?.longitude ?? 9.219832454)
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regioncoordinate.latitude, longitude: regioncoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.points.append(AnnotatedItem(name: name ?? "", coordinate: .init(latitude: regioncoordinate.latitude, longitude: regioncoordinate.longitude)))
            
//            MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 48.687330584, longitude: 9.219832454),
//            latitudinalMeters: 1000000,
//            longitudinalMeters: 1000000)
    }
    
    func update(name: String? = "", coordinate: Coordinate?) {
        let regioncoordinate = coordinate ?? MapModel.testcoordinate
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regioncoordinate.latitude, longitude: regioncoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.points = [AnnotatedItem(name: name ?? "", coordinate: .init(latitude: regioncoordinate.latitude, longitude: regioncoordinate.longitude))]
    }
    
    //San Jose region
    static let testregion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.335480, longitude: -121.893028), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    static let testcoordinate = Coordinate(latitude: 37.335480, longitude: -121.893028)
}
