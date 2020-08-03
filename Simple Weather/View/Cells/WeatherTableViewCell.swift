//
//  WeatherTableViewCell.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let reusableCell = "cell"
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityWeatherConditionLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = label.font.withSize(35.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
        configureNameLabel()
        configureTemperatureLabel()
        configureWeatherStatusLabel()
    }
    
    private func configureNameLabel() {
        contentView.addSubview(cityNameLabel)
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 11),
            cityNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            cityNameLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func configureTemperatureLabel() {
        contentView.addSubview(cityTemperatureLabel)
        
        NSLayoutConstraint.activate([
            cityTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityTemperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            cityTemperatureLabel.heightAnchor.constraint(equalTo: heightAnchor),
            cityTemperatureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -11),
            cityTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configureWeatherStatusLabel() {
        contentView.addSubview(cityWeatherConditionLabel)
        
        NSLayoutConstraint.activate([
            cityWeatherConditionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityWeatherConditionLabel.heightAnchor.constraint(equalTo: heightAnchor),
            cityWeatherConditionLabel.rightAnchor.constraint(equalTo: cityTemperatureLabel.leftAnchor, constant: -11),
            cityWeatherConditionLabel.widthAnchor.constraint(equalToConstant: 75),
            cityWeatherConditionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: WeatherModel) {
        cityNameLabel.text = model.name
        cityWeatherConditionLabel.text = Condition.cases[model.weather]
        cityTemperatureLabel.text = String.roundDouble(number: model.temperature) + Settings.metrics
    }
    
}
