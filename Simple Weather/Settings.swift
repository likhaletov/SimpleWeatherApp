//
//  Settings.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 19.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

enum Settings {
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "b654915f8bfc4ae99a30aa1bc7159127"
    static let cityId = "&id="
    static let currentWeatherAPI = "weather?appid="
    static let forecastWeatherAPI = "onecall?&exclude=minutely,current,hourly&appid="
    static var apiMetrics: Metrics = .metric
    static var metrics = Degrees.celsius
    static let saveFileName = "structs.json"
}


enum Metrics: String {
    case metric
    case imperial
}

enum Degrees {
    static let celsius = "°C"
    static let fahrenheit = "°F"
}

enum Forecast {
    case current
    case forecast5
}

enum Condition {
    static let cases = [
        "Thunderstorm" : "⛈",
        "Drizzle" : "🌧",
        "Rain" : "☔️",
        "Snow" : "❄️",
        "Clear" : "✨",
        "Clouds" : "☁️"
    ]
}
