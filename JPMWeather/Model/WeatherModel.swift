//
//  WeatherModel.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import Foundation


//Very simple Codables. As our app scales up we should
//probably come up with better names and use codingkeys 
struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main : Codable {
    let temp : Double
    let feelsLike : Double
    let tempMin : Double
    let tempMax : Double
}

struct Weather : Codable {
    let main: String
    let description: String
    let icon: String
}
