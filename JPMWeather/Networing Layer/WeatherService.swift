//
//  WeatherService.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import Foundation

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
protocol WeatherProtocol : APIProvider {
    var urlProvider : GetWeatherURLProvider { get }
    func makeRequest(with completion: @escaping (Result<WeatherResponse, APIError>) -> Void)
}

//simple protocol oriented networking instance for grabbing weather data
class GetWeatherURLProvider : URLProvider {
    var path: String {
        return "/data/2.5/weather"
    }
    
    var queryItems : [URLQueryItem] {
        [
        URLQueryItem(name: "lat", value: lat),
        URLQueryItem(name: "lon", value: lon),
        URLQueryItem(name: "units", value: "imperial"),
        URLQueryItem(name: "appid", value: "e40fb9763f108da8bc3f22c4e5484d9e")
        ]
    }
    
    var lat : String
    var lon : String
    
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}


class WeatherService : WeatherProtocol {
    
    let urlProvider = GetWeatherURLProvider(lat: "", lon: "")
    
    func makeRequest(with completion: @escaping (Result<WeatherResponse, APIError>) -> Void) {
        load(urlProvider.url, withCompletion: completion)
    }
}





