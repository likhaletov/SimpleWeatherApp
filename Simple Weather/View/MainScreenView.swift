//
//  MainScreenView.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 27.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

final class MainScreenView: UIView {
    
    lazy var currentWeatherView: UIView = {
        let hv = UIView()
        hv.backgroundColor = .white
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
    }()
    
    lazy var currentWeatherLabel: UILabel = {
        let l = UILabel()
        l.text = "..."
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var weatherTableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHeaderView()
        configureCurrentWeatherLabel()
        configureWeatherTableView()
    }
    
    private func configureHeaderView() {
        addSubview(currentWeatherView)

        NSLayoutConstraint.activate([
            currentWeatherView.widthAnchor.constraint(equalTo: widthAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/10),
            currentWeatherView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configureCurrentWeatherLabel() {
        currentWeatherView.addSubview(currentWeatherLabel)
        
        NSLayoutConstraint.activate([
            currentWeatherLabel.centerXAnchor.constraint(equalTo: currentWeatherView.centerXAnchor),
            currentWeatherLabel.centerYAnchor.constraint(equalTo: currentWeatherView.centerYAnchor)
        ])
    }
    
    private func configureWeatherTableView() {
        
        weatherTableView.estimatedRowHeight = 44.0
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.reusableCell)
        
        addSubview(weatherTableView)
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
