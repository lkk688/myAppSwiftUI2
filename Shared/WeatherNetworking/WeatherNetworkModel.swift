//
//  WeatherNetworkModel.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import Foundation
import Combine
import CoreLocation

class WeatherNetworkModel: ObservableObject {
    //@Published var city: String = "Atlanta,us"
    @Published var weatherresponse: OneWeatherAPIResponse?
    @Published var weather: String = ""
    
    private let locationManager = CLLocationManager()
    private lazy var location: CLLocation? = locationManager.location
    
    static var weatherJSONDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    private var bag = Set<AnyCancellable>()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) //The shared singleton session object. For basic requests, the URLSession class provides a shared singleton session object that gives you a reasonable default behavior for creating tasks.
    {
        self.session = session
    }
    
    func getWeather(querycity: String)
    {
        //        let apikey = OpenWeatherAPI.key
        let city = "Atlanta,us"
        //let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apikey)")!
        //let weatherURL = URL(string:"https://api.openweathermap.org/data/2.5/weather?id=524901&APPID=2b492c001d57cd5499947bd3d3f9c47b")!
        let weatherURL = makeCurrentDayForecastComponents(withCity: city).url!
        //First way
        //        self.session.dataTask(with: weatherURL) { data, response, error in
        //            if let error = error {
        //                print("Error:\n\(error)")
        //                fatalError("Error: \(error.localizedDescription)")
        //            } else {
        //                do {
        //                    let weather = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
        //                    print("Temperature \(weather["main"]!["temp"]!!)°C Humidity \(weather["main"]!["humidity"]!!)% Pressure \(weather["main"]!["pressure"]!!)hPa.")
        //                } catch let jsonError as NSError {
        //                    print("JSON error:\n\(jsonError.description)")
        //                }
        //            }
        //        }.resume()
        
        //Second way
        let task = self.session.dataTask(with: weatherURL) { data, response, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                fatalError("Error: invalid HTTP response code")
            }
            guard let data = data else {
                fatalError("Error: missing response data")
            }
            
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode(CurrentWeatherForecastResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.weather = "Temperature \(posts.main.temperature)°C Humidity \(posts.main.humidity)% ."
                    print(self.weather)
                }
            }
            catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    //Using Combine
    func getWeatherCombine(querycity: String) -> AnyPublisher<Data, Error> {
        let weatherURL = makeCurrentDayForecastComponents(withCity: querycity).url!

        let urlRequest = URLRequest(url: weatherURL,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                $0.data
                
            }
            .eraseToAnyPublisher()
    }
    
    func getWeatherCombine(location: Coordinate) -> AnyPublisher<Data, Error> {
        let weatherURL = makeOneCallAPIComponents(coordinate: location).url! //.url!

        let urlRequest = URLRequest(url: weatherURL,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                $0.data
                
            }
            .eraseToAnyPublisher()
    }
    
    func requestCurrentWeather(querycity: String) {
        return self.getWeatherCombine(querycity: querycity)
            .decode(type: CurrentWeatherForecastResponse.self, decoder: WeatherNetworkModel.weatherJSONDecoder)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in //[weak self]
                    //self?.weather = "receiveCompletion"
                    print("receiveCompletion")
                },
                receiveValue: { [weak self] weather in
                    //self?.weather = "Temperature \(posts.main.temperature)°C Humidity \(posts.main.humidity)% ."//weather
                    print(weather)
                    self?.weather = "Combine Temperature \(weather.main.temperature)°C Humidity \(weather.main.humidity)% ."
                }
            )
            .store(in: &bag)
    }
    
    func requestCurrentLocationWeatherCombine() -> AnyPublisher<Data, Error>{
        locationManager.requestWhenInUseAuthorization()

        guard CLLocationManager.locationServicesEnabled() else {
            return Fail(error: WeatherServiceErrors.userDeniedWhenInUseAuthorization)
                .eraseToAnyPublisher()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()

        guard let location = location else {
            return Fail(error: WeatherServiceErrors.locationNil)
                .eraseToAnyPublisher()
        }

        return self.getWeatherCombine(location: Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            .eraseToAnyPublisher()
    }
    
    func requestCurrentLocationWeather() {
        return self.requestCurrentLocationWeatherCombine()
                    .decode(type: OneWeatherAPIResponse.self, decoder: WeatherNetworkModel.weatherJSONDecoder)
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { _ in //[weak self]
                            //self?.weather = "receiveCompletion"
                            print("receiveCompletion")
                        },
                        receiveValue: { [weak self] weather in
                            //self?.weather = "Temperature \(posts.main.temperature)°C Humidity \(posts.main.humidity)% ."//weather
                            print(weather)
                            //self?.weather = "Temperature \(weather.current.temperature)°C Humidity \(weather.current.humidity)% ."
                            self?.weatherresponse = weather
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .medium
                            dateFormatter.timeStyle = .none
                            dateFormatter.locale = Locale(identifier: "en_US")
                            let datastr=dateFormatter.string(from: weather.current.currenttime) // Jan 2, 2001

                            self?.weather = "Temperature \(weather.current.temperature)°C Humidity \(weather.current.humidity)% \(weather.current.weather[0].main) \(datastr)."
                        }
                    )
                    .store(in: &bag)
    }
}



private extension WeatherNetworkModel {
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "2b492c001d57cd5499947bd3d3f9c47b"//<your key>"
    }
    
    func makeWeeklyForecastComponents(
        withCity city: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/forecast"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
    
    func makeCurrentDayForecastComponents(
        withCity city: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/weather"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
    
    //https://openweathermap.org/api/one-call-api
    func makeOneCallAPIComponents(
        coordinate: Coordinate
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/onecall"
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%.6f", coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(format: "%.6f", coordinate.longitude)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
}

private extension WeatherNetworkModel {
    struct Constants {
        static let gettingYourLocationText = "Getting your location".localized()
        static let gettingLocationErrorText = "Can't get your location name".localized()
    }
}

