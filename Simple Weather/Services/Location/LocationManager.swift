//
//  LocationManager.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 19.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    
    var lon: CLLocationDegrees?
    var lat: CLLocationDegrees?
    
    weak var coordinatesDelegate: UpdateCurrentCoordinates?
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
}

extension LocationManager: LocationManagerProtocol {
    
    func getLon() -> CLLocationDegrees {
        if let lon = lon {
            return lon
        }
        return 0.0
    }
    
    func getLat() -> CLLocationDegrees {
        if let lat = lat {
            return lat
        }
        return 0.0
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.lon = location.coordinate.longitude
            self.lat = location.coordinate.latitude
            coordinatesDelegate?.didUpdateCoordinates(with: location)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            manager.stopUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        @unknown default:
            fatalError()
        }
        
    }
}
