//
//  APIProvider.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import Foundation

enum APIError : Error {
    case unableToDecode
    case invalidResponse
    case badInput
}
//simple protocol that works with the APIProvider below to create a URL
protocol URLProvider: AnyObject {
    var url: URL { get }
    var queryItems : [URLQueryItem] { get }
    var path: String { get }
}

extension URLProvider {
    var url : URL {
        var components = URLComponents(string: "https://api.openweathermap.org")!
        components.path = path
        if self.queryItems.count > 0 {
            components.queryItems = self.queryItems
        }
        return components.url!
    }
}

//Basis of the networking layer for this project that follows a protocol oriented approach.
//For this project this is probably overkill and a Singleton would've been fine, but as the application scales
//that would cause problems. This is also significantly more testable and mockable, and given more time I would've
//spent some time testing this.
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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
