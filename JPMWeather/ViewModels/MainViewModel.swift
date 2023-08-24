//
//  MainViewModel.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import UIKit

class MainViewModel {
    //different API services we rely on in this view model.
    //all protocols in order to increase testability and mocking
    //didn't have time to write many tests for this class, but
    //tests should be relatively simple as this class was written
    //with testability in mind.
    let coordinatesService: any CoordinatesProtocol
    let weatherService: any WeatherProtocol
    let imageLoader: ImageProvider
    @Published var image: UIImage?
    private var callWorkItem: DispatchWorkItem?
    
    init(coordinatesService: any CoordinatesProtocol = CoordinatesService(),
         weatherService: any WeatherProtocol = WeatherService(),
         imageLoader: ImageProvider = ImageLoader()){
        self.coordinatesService = coordinatesService
        self.weatherService = weatherService
        self.imageLoader = imageLoader
    }
    
    //grabs the coordinates from input. This could be improved as the endpoint also takes in a
    //formatted state and zipcode, and would improve on it given more time.
    //Uses DispatchWorkItem (GCD) to prevent making constant API calls as the user types in a character
    //Adds in a slight delay that we should test and tweak, but good enough for a starter project.
    func makeCoordinatesCall(with input: String, completion: @escaping (Result<[GeoLocation], APIError>) -> Void){
        guard !input.isEmpty else {
            completion(.failure(.badInput))
            return
            
        }
        callWorkItem?.cancel()
        
        callWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.coordinatesService.urlProvider.input = input
            self?.coordinatesService.makeRequest(with: completion)
        })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500), execute: callWorkItem!)
    }
    
    func loadImage(id: String) {
        imageLoader.makeRequest(id: id) { result in
            switch result {
            case .success(let success):
                self.image = success
            case .failure(_):
                //again, need better error handling given more time
                break
            }
        }
    }
    
    func makeWeatherRequest(lat: String, long: String, completion: @escaping (Result<WeatherResponse, APIError>) -> Void) {
        //using UserDefaults to persist latitude and longitude. Since we just need
        //to store two simple strings, UserDefaults is fine to use.
        UserDefaults.standard.set(lat, forKey: "geolat")
        UserDefaults.standard.set(long, forKey: "geolon")
        weatherService.urlProvider.lat = lat
        weatherService.urlProvider.lon = long
        weatherService.makeRequest { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func formatHighLowLabel(response: WeatherResponse) -> String {
        return "H:\(Int(response.main.tempMax))° L:\(Int(response.main.tempMin))°"
    }
}
