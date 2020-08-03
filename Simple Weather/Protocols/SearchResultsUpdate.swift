//
//  SearchResultsUpdate.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import MapKit

protocol SearchResultsUpdate: AnyObject {
    func didSearchResultsUpdate(with array: [MKLocalSearchCompletion])
}
