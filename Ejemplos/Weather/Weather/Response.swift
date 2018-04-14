//
//  Weather.swift
//  Weather
//
//  Created by José Brandon Vargas Mariñelarena on 06/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Response: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct Clouds: Codable {
    let all: Int?
}

struct Coord: Codable {
    let lon, lat: Double?
}

struct Main: Codable {
    let temp, pressure: Double?
    let humidity: Int?
    let tempMin, tempMax, seaLevel, grndLevel: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Sys: Codable {
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed, deg: Double?
}

