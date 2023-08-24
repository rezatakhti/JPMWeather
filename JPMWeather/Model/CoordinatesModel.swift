//
//  CoordinatesModel.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import Foundation

//Very simple Codables. As our app scales up we should
//probably come up with better names and use codingkeys 
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
