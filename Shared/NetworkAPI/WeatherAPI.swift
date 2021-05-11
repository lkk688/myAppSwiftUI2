//
//  WeatherAPIProtocol.swift
//  myAppSwiftUI2 (iOS)
//
//  Created by Kaikai Liu on 4/18/21.
//

import Foundation
import Combine
import MapKit //for CLLocationCoordinate2D

protocol WeatherAPIProtocol {
    func getWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<OneWeatherAPIResponse, NetworkAPIError>
    //display the weather forecast for the next five days
    //The first parameter (OneWeatherAPIResponse) refers to the type it returns if the computation is successful
    //the second refers to the type if it fails (WeatherError).
}

struct CurrentWeatherRowViewModel {
    private let item: OneWeatherAPIResponse

    var temperature: String {
        return String(format: "%.1f", item.current.temperature)
    }

    var feelslike: String {
        return String(format: "%.1f", item.current.feelslike)
    }

    var pressure: String {
        return String(format: "%d", item.current.pressure)
    }

    var humidity: String {
        return String(format: "%d", item.current.humidity)
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: item.lat, longitude: item.lon)
    }
    
    var weathercondition: String {
        return item.current.weather[0].main
    }

    init(item: OneWeatherAPIResponse) {
        self.item = item
    }
}

class WeatherService: WeatherAPIProtocol {
    private let networkAPI = NetworAPIProvider()
    
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "2b492c001d57cd5499947bd3d3f9c47b"//<your key>"
    }
    
    //implement protocol function
    func getWeatherForecast(forCity city: String) -> AnyPublisher<OneWeatherAPIResponse, NetworkAPIError> {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/onecall"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
//        components.queryItems = [
//            URLQueryItem(name: "lat", value: String(format: "%.6f", coordinate.latitude)),
//            URLQueryItem(name: "lon", value: String(format: "%.6f", coordinate.longitude)),
//            URLQueryItem(name: "units", value: "metric"),
//            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
//        ]
        return networkAPI.fetch(with: components)
            .eraseToAnyPublisher()
    }
}

class WeatherAPIModel: ObservableObject, Identifiable{
    
    // Expose an optional CurrentWeatherRowViewModel as the data source
    @Published var dataSource: CurrentWeatherRowViewModel?
    let city: String
    private let weatherFetcher: WeatherService
    private var disposables = Set<AnyCancellable>()
    
    init(city: String, weatherFetcher: WeatherService) {
        self.weatherFetcher = weatherFetcher
        self.city = city
    }
    
    func refresh() {
        weatherFetcher
            .getWeatherForecast(forCity: city)
            //Transform new values to a CurrentWeatherRowViewModel as they come in the form of a CurrentWeatherForecastResponse format
            .map(CurrentWeatherRowViewModel.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.dataSource = nil
                case .finished:
                    break
                }
                }, receiveValue: { [weak self] weather in
                    guard let self = self else { return }
                    self.dataSource = weather
            })
            .store(in: &disposables)
    }
}
