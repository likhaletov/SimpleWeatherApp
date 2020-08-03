//
//  PersistentManagerProtocol.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 28.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

protocol PersistentManagerProtocol {
    var filename: String { get }
    func getURL() -> URL
    func saveData<T: Encodable>(model: [T])
    func loadData() -> [WeatherModel]
    init(filename: String)
}
