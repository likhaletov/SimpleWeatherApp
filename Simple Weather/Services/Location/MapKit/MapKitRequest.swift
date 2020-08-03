//
//  MapKitRequest.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import MapKit

class MapKitRequest {
    
    class func makeRequest(with query: String, completion: @escaping ((MKPlacemark) -> Void)) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            if let placemark = response.mapItems.first?.placemark {
                completion(placemark)
            }
        }
        
    }
    
}
