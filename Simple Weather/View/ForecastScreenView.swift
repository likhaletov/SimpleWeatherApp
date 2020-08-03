//
//  ForecastScreenView.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 26.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
//import MapKit

final class ForecastScreenView: UIView {
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = .zero
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var weatherForecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Week forecast"
        label.font = label.font.withSize(31)
        label.textAlignment = .center
        label.sizeToFit()
//        label.backgroundColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.sizeToFit()
//        button.backgroundColor = UIColor.green
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    lazy var forecastMapKitView: MKMapView = {
//        let map = MKMapView()
//        map.translatesAutoresizingMaskIntoConstraints = false
//        return map
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 15


//        configureStackView()
        
        configureHeaderLabel()
        configureCollectionView()
        configureDismissButton()
//        configureMap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(weatherForecastCollectionView)
        stackView.addArrangedSubview(dismissButton)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureHeaderLabel() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func configureCollectionView() {
        weatherForecastCollectionView.backgroundColor = .white
        
        addSubview(weatherForecastCollectionView)

        NSLayoutConstraint.activate([
            weatherForecastCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            weatherForecastCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherForecastCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherForecastCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height / 2.5)
        ])
    }
    
    private func configureDismissButton() {
        addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.heightAnchor.constraint(equalToConstant: 44.0),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            dismissButton.topAnchor.constraint(equalTo: weatherForecastCollectionView.bottomAnchor)
        ])
    }
    
//    private func configureMap() {
//        addSubview(forecastMapKitView)
//        NSLayoutConstraint.activate([
//            forecastMapKitView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            forecastMapKitView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            forecastMapKitView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//            forecastMapKitView.heightAnchor.constraint(equalToConstant: 150)
//        ])
//    }
    
}
