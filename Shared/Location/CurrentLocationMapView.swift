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
                
            }
            //Search weather via city
            VStack{
                HStack{
                    Text("Search Weather")
                    
                    ZStack{
                        TextField("Search other cities, e.g. Cupertino", text: $weatherNetworkModel.city, onEditingChanged: { (changed) in
                            print("City onEditingChanged - \(changed)")
                            //gets called when user taps on the TextField or taps return. The changed value is set to true when user taps on the TextField and it’s set to false when user taps return.
                        }) {
                            //The onCommit callback gets called when user taps return.
                            print("City onCommit")
                            //self.viewModel.fetchWeather(forCity: self.viewModel.city)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        ActivityIndicator(shouldAnimate: $weatherNetworkModel.activityshouldAnimate)
                    }
                }
                //Display current weather for the searched city
                Text("The weather for City \(weatherNetworkModel.city) is \(weatherNetworkModel.weather)").padding()
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
