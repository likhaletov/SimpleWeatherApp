//
//  NetworkManagerProtocol.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 26.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func obtain(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
