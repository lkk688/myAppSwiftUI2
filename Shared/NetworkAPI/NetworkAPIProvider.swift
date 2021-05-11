//
//  NetworkAPIProvider.swift
//  myAppSwiftUI2 (iOS)
//
//  Created by Kaikai Liu on 4/18/21.
//

import Foundation
import Combine

enum NetworkAPIError: Error {
    case parsing(description: String)
    case network(description: String)
}

class NetworAPIProvider {
    private var cancellable: AnyCancellable?
    
    private let session: URLSession
    
    init(session: URLSession = .shared) //The shared singleton session object. For basic requests, the URLSession class provides a shared singleton session object that gives you a reasonable default behavior for creating tasks.
    {
        self.session = session
    }
    
    func fetch<T>(
        with components: URLComponents
    ) -> AnyPublisher<T, NetworkAPIError> where T: Decodable //T here is a Decodable object and our goal is to take the data that’s returned by a network call and to decode tLhis data into a model of type T.
    {
        //create an instance of URL from the URLComponents.
        guard let url = components.url else {
            //the method returns AnyPublisher<T, WeatherError>, you map the error from URLError to WeatherError.
            let error = NetworkAPIError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
            //Fail publisher that immediately terminates with the specified failure.
            //If this fails, return an error wrapped in a Fail value. Then, erase its type to AnyPublisher, since that’s the method’s return type.
        }
        
        //returns a publisher so that other objects can subscribe to this publisher, and can handle the result of the network call
            //Uses the new URLSession method dataTaskPublisher(for:) to fetch the data, takes an instance of URLRequest and returns either a tuple (Data, URLResponse) or a URLError
        print(url.absoluteString)
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            //decode(type:decoder:) can only be used on publishers that have an Output of Data. To do this, we can map the output of the data task publisher and feed the result of this map operation to the decode operation:
            self.decode(pair.data)
            //takes the Output of the URLSession.DataTaskPublisher which is (data: Data, response: URLResponse) and transforms that into a publisher whose Output is Data using the map operator.
        }
        .eraseToAnyPublisher()
        //In order to hide the details of our publisher chain, and to make the return type more readable we must convert our publisher chain to a publisher of type AnyPublisher. We can do this by using the eraseToAnyPublisher after the decode(type:decoder:) operator.
    }
    
    //decode: utility method to convert the data into a decoded object
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkAPIError> {
        let decoder = JSONDecoder()//This uses a standard JSONDecoder to decode the JSON from the OpenWeatherMap API.
        decoder.dateDecodingStrategy = .secondsSince1970
        
        //struct Just<Output>: A publisher that emits an output to each subscriber just once, and then finishes.
        //ref: https://developer.apple.com/documentation/combine/just
        //Just publisher completes immediately with the supplied value, it can never produce an error, and it’s a valid publisher to use in the catch operator
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
        //we need to use eraseToAnyPublisher() to transform the result of the catch operator to AnyPublisher to avoid having to write Publishers.Catch<AnyPublisher<PhotoFeed, Error>, Publisher> as our return type.
    }
}
