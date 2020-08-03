//
//  JSON+CurrentWeatherModel.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 19.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Int
    let name: String
    let weather: [WeatherObject]
    let main: WeatherMainObject
    let coord: WeatherCoordObject
}

struct WeatherObject: Decodable {
    let main: String
}

struct WeatherMainObject: Decodable {
    let temp: Double
    let humidity: Int
}

struct WeatherCoordObject: Decodable {
    let lon: Double
    let lat: Double
}
