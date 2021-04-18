//
//  NetworkErrors.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/13/21.
//

import Foundation

enum APIErrors: Int, LocalizedError {
    case badRequest = 400
    case unAuthorized = 401
    case tooManyRequests = 429
    case serverError = 500
    
    var errorDescription: String? {
        switch self {
        case .tooManyRequests:
            return "You made too many requests within a window of time and have been rate limited. Back off for a while.".localized()
        case .serverError:
            return "Server error.".localized()
        default:
            return "Something goes wrong.".localized()
        }
    }
}

enum APIProviderErrors: LocalizedError {
    case invalidURL
    case dataNil
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .dataNil:
            return "Empty data.".localized()
        case .decodingError:
            return "Data has invalid format.".localized()
        default:
            return "Something goes wrong.".localized()
        }
    }
}

enum WeatherServiceErrors: LocalizedError {
    case userDeniedWhenInUseAuthorization
    case locationNil
    case placeMarkNil
    
    var errorDescription: String? {
        switch self {
        case .userDeniedWhenInUseAuthorization:
            return "You've denied location authorization".localized()
            
        case .locationNil:
            return "Something goes wrong.".localized()
            
        case .placeMarkNil:
            return "Can't get location name"
        }
    }
}
