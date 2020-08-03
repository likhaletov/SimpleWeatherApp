//
//  WeatherModel.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let id: Int
    let name: String
    let lat: Double
    let lon: Double
    let weather: String
    var temperature: Double
    let humidity: Int
}
