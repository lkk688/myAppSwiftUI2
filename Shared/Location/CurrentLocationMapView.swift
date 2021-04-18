//
//  CurrentLocationMapView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import SwiftUI

struct CurrentLocationMapView: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    @StateObject var weatherNetworkModel = WeatherNetworkModel()
    
    var body: some View {
        VStack{
            MapView(mapmodel: locationViewModel.mapmodel)
            Text("Location updating: \(locationViewModel.isUpdating.description)").padding()
//            Text("Current place: \(locationViewModel.placemark?.description ?? "")").padding()
            Text("Current place: \(locationViewModel.placemark?.name ?? "")").padding()
            Text("Current weather: \(weatherNetworkModel.weather)").padding()
            HStack{
                Button("Start Location") {
                    //locationViewModel.startLocationUpdate()
//                    weatherNetworkModel.getWeather(querycity: locationViewModel.placemark?.name ?? "San Jose,CA")
//                    weatherNetworkModel.requestCurrentWeather(querycity: "Atlanta,us")
                    
                    weatherNetworkModel.requestCurrentLocationWeather()
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
        }.onAppear{
            locationViewModel.startLocationUpdate()
        }
    }
}

struct CurrentLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationMapView()
    }
}
