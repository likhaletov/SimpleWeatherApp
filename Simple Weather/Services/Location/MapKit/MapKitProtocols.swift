//
//  MapKitProtocols.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 01.08.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import MapKit

protocol MapKitCompleterProtocol: AnyObject {
    var completer: MKLocalSearchCompleter { get set }
    var updateDelegate: SearchResultsUpdate? { get set }
    var searchResultsItems: [MKLocalSearchCompletion] { get set }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
}
