//
//  UpdateCurrentCoordinates.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import CoreLocation

protocol UpdateCurrentCoordinates: AnyObject {
    func didUpdateCoordinates(with coordinates: CLLocation)
}
