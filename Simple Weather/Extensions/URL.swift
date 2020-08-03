//
//  Extensions.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 21.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

extension URL {
    
    static func getAPI(lat: Double, lon: Double, forecast: Forecast = .current, units: Metrics) -> URL {
        
        let baseURL = Settings.baseURL
        let currentWeatherAPI = Settings.currentWeatherAPI
        let forecastWeatherAPI = Settings.forecastWeatherAPI
        let api = Settings.apiKey
        
        switch forecast {
        case .current:
            let url = baseURL + currentWeatherAPI + api + "&lat=" + String(lat) + "&lon=" + String(lon) + "&units=" + units.rawValue
            return URL(string: url)!
        case .forecast5:
            let url = baseURL + forecastWeatherAPI + api + "&lat=" + String(lat) + "&lon=" + String(lon) + "&units=" + units.rawValue
            print(url)
            
            return URL(string: url)!
        }
        
    }
    
    static func getAPI(id: Int, units: Metrics = .metric) -> URL {
        let baseURL = Settings.baseURL
        let currentWeatherAPI = Settings.currentWeatherAPI
        let api = Settings.apiKey
        let cityID = Settings.cityId
        
        let url = baseURL + currentWeatherAPI + api + cityID + String(id) + "&units=" + units.rawValue
        
        return URL(string: url)!
    }
    
}
