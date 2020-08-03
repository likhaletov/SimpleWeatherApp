//
//  LocationManagerProtocol.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 23.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    func getLat() -> CLLocationDegrees
    func getLon() -> CLLocationDegrees
    var coordinatesDelegate: UpdateCurrentCoordinates? { get set }
}
