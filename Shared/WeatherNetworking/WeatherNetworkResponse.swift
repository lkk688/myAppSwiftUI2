//
//  WeatherNetworkResponse.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import Foundation

struct WeeklyForecastResponse: Codable {
    let list: [Item]
    
    struct Item: Codable {
        let date: Date
        let main: MainClass
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main
            case weather
        }
    }
    
    struct MainClass: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: MainEnum
        let weatherDescription: String
        
        enum CodingKeys: String, CodingKey {
            case main
            case weatherDescription = "description"
        }
    }
    
    enum MainEnum: String, Codable {
        case clear = "Clear"
        case clouds = "Clouds"
        case rain = "Rain"
    }
    
}


//https://api.openweathermap.org/data/2.5/weather?q=San%20Jose,us&APPID=2b492c001d57cd5499947bd3d3f9c47b
//{"coord":{"lon":-121.895,"lat":37.3394},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":297.48,"feels_like":296.75,"temp_min":295.15,"temp_max":298.71,"pressure":1020,"humidity":30},"visibility":10000,"wind":{"speed":2.57,"deg":310},"clouds":{"all":1},"dt":1618771890,"sys":{"type":1,"id":5661,"country":"US","sunrise":1618752488,"sunset":1618800305},"timezone":-25200,"id":5392171,"name":"San Jose","cod":200}
struct CurrentWeatherForecastResponse: Codable {
    let coord: Coord
    let main: Main
    
    struct Main: Codable {
        let temperature: Double
        let humidity: Int
        let maxTemperature: Double
        let minTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case maxTemperature = "temp_max"
            case minTemperature = "temp_min"
        }
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}

//https://openweathermap.org/api/one-call-api
struct OneWeatherAPIResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentWeather
    
    struct CurrentWeather: Codable {
        let currenttime: Date
        let sunrise: Date
        let sunset: Date
        let temperature: Double
        let feelslike: Double
        let pressure: Int
        let humidity: Int
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case currenttime="dt"
            case sunrise
            case sunset
            case temperature = "temp"
            case feelslike = "feels_like"
            case pressure
            case humidity
            case weather = "weather"
        }
    }
    
//    struct Coord: Codable {
//        let lon: Double
//        let lat: Double
//    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}


