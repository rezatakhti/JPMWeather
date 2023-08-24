//
//  ImageLoader.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/22/23.
//

import UIKit

protocol ImageProvider {
    func makeRequest(id: String, with completion: @escaping (Result<UIImage, APIError>) -> Void)
}

//Image loader with simple caching using NSCache.
//This could definitely be improved and we could always use a
//third party library like kingfisher, but for this simple usecase
//this is more than fine.
//This class basically sees if we have the cached image available, and
//if not makes a call to download the image.
class ImageLoader : ImageProvider {
    let urlProvider: ImageURLProvider
    let imageCache : NSCache<NSString, NSData> = NSCache()
    
    init(id: String? = nil){
        self.urlProvider = ImageURLProvider(id: id ?? "")
    }
    
    func makeRequest(id: String, with completion: @escaping (Result<UIImage, APIError>) -> Void) {
        if let data = imageCache.object(forKey: urlProvider.id as NSString),
           let image = UIImage(data: data as Data) {
            completion(.success(image))
        }
        self.urlProvider.id = id
        let task = URLSession.shared.dataTask(with: urlProvider.url) { [weak self] (data, _ , _) -> Void in
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(.failure(.unableToDecode)) }
                return
            }
            if let self = self {
                self.imageCache.setObject(data as NSData, forKey: self.urlProvider.id as NSString)
            }
            DispatchQueue.main.async { completion(.success(image)) }
        }
        task.resume()
    }
    
}

//https://openweathermap.org/img/wn/10d@2x.png
class ImageURLProvider: URLProvider {
    var path: String {
        return "/img/wn/\(id)@2x.png"
    }
    
    var queryItems: [URLQueryItem] = []
    
    var id: String
    init(id: String){
        self.id = id
    }
    
    var url : URL {
        var components = URLComponents(string: "https://openweathermap.org")!
        components.path = path
        return components.url!
    }
}
