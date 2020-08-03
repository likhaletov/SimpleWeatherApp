//
//  JSON+ForecastWeatherModel.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 24.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

struct WeatherForecast: Decodable {
    let daily: [WeatherForecastDaily]
}

struct WeatherForecastDaily: Decodable {
    let dt: Double
    let temp: WeatherForecastTemp
    let weather: [WeatherForecastWeather]
}

struct WeatherForecastTemp: Decodable {
    let day: Double
    let night: Double
}

struct WeatherForecastWeather: Decodable {
    let main: String
}
