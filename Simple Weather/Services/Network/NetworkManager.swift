//
//  NetworkManager.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 19.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badRequest
}

class NetworkManager: NetworkManagerProtocol {
    
    func obtain(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard response != nil else { return }
            guard let data = data else { return }
            
            if error != nil {
                completion(.failure(.badRequest))
                return
            } else {
                completion(.success(data))
            }
        
        }
        task.resume()
    }
    
}
