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
    var searchResultsItems: [MKLocalSearchCompletion] = []
    weak var updateDelegate: SearchResultsUpdate?
    
    override init() {
        super.init()
        completer.delegate = self
        if #available(iOS 13.0, *) {
            let filter = MKPointOfInterestFilter(including: [.airport])
            completer.pointOfInterestFilter = filter
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension MapKitCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResultsItems = completer.results
        updateDelegate?.didSearchResultsUpdate(with: searchResultsItems)
    }
}
