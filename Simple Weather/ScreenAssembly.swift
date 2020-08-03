//
//  ScreenAssembly.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 08.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

protocol Assembly {
    static func createMainScreen() -> UIViewController
    static func createForecastScreen(lon: Double, lat: Double) -> UIViewController
    static func createSearchScreen() -> UIViewController
}

class ScreenAssembly: Assembly {
    
    class func createMainScreen() -> UIViewController {
        let locationManager = LocationManager()
        let networkManager = NetworkManager()
        let persistentManager = PersistentManager(filename: Settings.saveFileName)
        
        let view = MainScreenViewController(
            locationManager: locationManager,
            networkManager: networkManager,
            persistentManager: persistentManager
        )
        
        return view
    }
    
    class func createForecastScreen(lon: Double, lat: Double) -> UIViewController {
        let networkService = NetworkManager()
        let view = ForecastScreenViewController(networkService: networkService, lon: lon, lat: lat)
        return view
    }
    
    class func createSearchScreen() -> UIViewController {
        let view = SearchScreenViewController(mapKitCompleter: MapKitCompleter())
        return view
    }
    
}
