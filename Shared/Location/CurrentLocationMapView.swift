//
//  CurrentLocationMapView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import SwiftUI

struct CurrentLocationMapView: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack{
            MapView(mapmodel: locationViewModel.mapmodel)
            Text("Location updating: \(locationViewModel.isUpdating.description)")
            Text("Current place: \(locationViewModel.placemark?.description ?? "")")
            HStack{
                Button("Start Location") {
                    locationViewModel.startLocationUpdate()
                }
                Button("Stop Location") {
                    locationViewModel.stopLocationUpdate()
                }
                Button("Go Home"){
                    locationViewModel.gohome()
                }
//                Toggle(isOn: $locationViewModel.isUpdating) {
//                    Text("Enable Location Update")
//                }
                
            }
        }
    }
}

struct CurrentLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationMapView()
    }
}
