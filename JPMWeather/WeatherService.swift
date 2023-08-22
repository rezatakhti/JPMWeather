//
//  WeatherService.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import Foundation

enum APIError : Error {
    case unableToDecode
    case invalidResponse
}

protocol URLProvider: AnyObject {
    var url: URL { get }
    var queryItems : [URLQueryItem] { get }
    var path: String { get }
}

extension URLProvider {
    var url : URL {
        var components = URLComponents(string: "https://api.openweathermap.org")!
        components.path = path
        components.queryItems = self.queryItems
        return components.url!
    }
}

protocol APIProvider : AnyObject {
    associatedtype T : Decodable
    associatedtype U : URLProvider
    var urlProvider : U { get }
    func makeRequest(with completion: @escaping (Result<T, APIError>) -> Void)
    func decode(_ data: Data) throws -> T?
}

extension APIProvider {
    func load(_ url: URL, withCompletion completion: @escaping (Result<T, APIError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlProvider.url) { [weak self] (data, _ , _) -> Void in
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }
            
            guard let value = try? self?.decode(data) else {
                DispatchQueue.main.async { completion(.failure(.unableToDecode)) }
                return
            }
            
            DispatchQueue.main.async { completion(.success(value)) }
        }
        task.resume()
    }
    
    func decode(_ data: Data) throws -> T? {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

class GetWeatherURLProvider : URLProvider {
    var path: String {
        return "data/2.5/weather"
    }
    
    lazy var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "lat", value: lat),
        URLQueryItem(name: "lon", value: lon),
        URLQueryItem(name: "appid", value: "e40fb9763f108da8bc3f22c4e5484d9e")
    ]
    
    let lat : String
    let lon : String
    
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}

class WeatherService : APIProvider {
    
    let urlProvider = GetWeatherURLProvider(lat: "??", lon: "??")
    
    func makeRequest(with completion: @escaping (Result<WeatherResponse, APIError>) -> Void) {
        load(urlProvider.url, withCompletion: completion)
    }
}


struct WeatherResponse: Codable {
    let weather: Weather
}

struct Weather : Codable {
    let main: String
    let description: String
    let icon: String
}

class GetCoordinatesURLProvider: URLProvider {
    var path: String {
        "geo/1.0/direct"
    }
    
    let input: String
    
    lazy var queryItems = [
        URLQueryItem(name: "q", value: input),
        URLQueryItem(name: "appid", value: "e40fb9763f108da8bc3f22c4e5484d9e")
    ]
    
    init(input: String) {
        self.input = input
        self.queryItems = queryItems
    }
}

class CoordinatesService: APIProvider {
    let urlProvider = GetCoordinatesURLProvider(input: "")
    
    func makeRequest(with completion: @escaping (Result<GetCoordinatesResponse, APIError>) -> Void) {
        load(urlProvider.url, withCompletion: completion)
    }
}

struct GetCoordinatesResponse: Codable {
    let locations: [GeoLocation]
}

struct GeoLocation : Codable {
    let name: String
    let lat : Double
    let lon : Double
    let country: String
    let state : String
}


