//
//  PersistentManager.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 23.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

public class PersistentManager: PersistentManagerProtocol {
    
    var filename: String
    
    required init(filename: String) {
        self.filename = Settings.saveFileName
    }

    func getURL() -> URL {
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("can't access to user document directory")
        }
        
    }
    
    func saveData<T: Encodable>(model: [T]) {
        
        let url = getURL().appendingPathComponent(filename)
        print(url.absoluteString)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(model)
            try data.write(to: url)
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func loadData<T: Decodable>() -> [T] {
        
        let url = getURL().appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: url.path) {
            
            let decoder = JSONDecoder()
            
            do {
                let data = try Data(contentsOf: url)
                let result = try decoder.decode([T].self, from: data)
                return result
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
        } else {
            print("shit =(")
            return []
        }
        
    }
    
}
