//
//  MapKitCompleter.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import MapKit

class MapKitCompleter: MKLocalSearchCompleter, MapKitCompleterProtocol {
    
    var completer = MKLocalSearchCompleter()
    let filter = MKPointOfInterestFilter(including: [.airport])
    var searchResultsItems: [MKLocalSearchCompletion] = []
    weak var updateDelegate: SearchResultsUpdate?
    
    override init() {
        super.init()
        completer.delegate = self
        completer.pointOfInterestFilter = filter
    }
    
}

extension MapKitCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResultsItems = completer.results
        updateDelegate?.didSearchResultsUpdate(with: searchResultsItems)
    }
}
