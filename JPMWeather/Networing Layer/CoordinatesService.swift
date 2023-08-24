//
//  CoordinatesService.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import Foundation

//http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}

//simple protocol oriented networking instance for grabbing coordinates
protocol CoordinatesProtocol : APIProvider {
    var urlProvider : GetCoordinatesURLProvider { get }
    func makeRequest(with completion: @escaping (Result<[GeoLocation], APIError>) -> Void)
}

class GetCoordinatesURLProvider: URLProvider {
    var path: String {
        "/geo/1.0/direct"
    }
    
    var input: String
    
    var queryItems : [URLQueryItem]  {
        [
            URLQueryItem(name: "q", value: input),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: "e40fb9763f108da8bc3f22c4e5484d9e")
        ]
    }
    
    init(input: String) {
        self.input = input
    }
}

class CoordinatesService: CoordinatesProtocol {
    let urlProvider = GetCoordinatesURLProvider(input: "")
    
    func makeRequest(with completion: @escaping (Result<[GeoLocation], APIError>) -> Void) {
        load(urlProvider.url, withCompletion: completion)
    }
}
