//
//  ForecastCollectionViewCell.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 25.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    static let reusableCell = "cell"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    
    func configure(with model: WeatherForecastDaily) {
    
        dateLabel.text = String.getNormalDate(unixEpochDate: model.dt)
        
        if let condition = model.weather.first?.main {
            weatherLabel.text = Condition.cases[condition]
        } else {
            weatherLabel.text = "N/A"
        }
        
        dayTempLabel.text = String.roundDouble(number: model.temp.day) + "°"
        nightTempLabel.text = String.roundDouble(number: model.temp.night) + "°"
        
    }

}
