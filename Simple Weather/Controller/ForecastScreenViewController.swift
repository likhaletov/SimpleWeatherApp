//
//  ForecastScreenViewController.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 24.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import MapKit

class ForecastScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let forecastView = ForecastScreenView()
    private let networkManager: NetworkManagerProtocol
    
    private var dataSource: [WeatherForecast] = []
    private var lat = 0.0
    private var lon = 0.0
    
    // MARK: - Load view
    override func loadView() {
        view = forecastView
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getForecast()
        configureUI()
    }
    
    private func configureUI() {
        title = "Week forecast"
        
        forecastView.backgroundColor = .white
        
        configureForecastCollectionView()
        configureDismissButton()
    }
    
    private func configureDismissButton() {
        forecastView.dismissButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true)
    }
    
    private func getForecast() {
        let dispatchGroup = DispatchGroup()
        
        let url = URL.getAPI(lat: lat, lon: lon, forecast: .forecast5, units: Settings.apiMetrics)
        
        dispatchGroup.enter()
        self.networkManager.obtain(from: url, completion: { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                
                do {
                    let object = try decoder.decode(WeatherForecast.self, from: data)
                    self.dataSource.append(object)
                    dispatchGroup.leave()
                } catch let error {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                dispatchGroup.leave()
            }
            
        })
        
        dispatchGroup.notify(queue: .main) {
            
            self.forecastView.weatherForecastCollectionView.reloadData()
        }
        
    }
    
    private func configureForecastCollectionView() {
        forecastView.weatherForecastCollectionView.delegate = self
        forecastView.weatherForecastCollectionView.dataSource = self
        
        let cellNib = UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
        forecastView.weatherForecastCollectionView.register(cellNib, forCellWithReuseIdentifier: ForecastCollectionViewCell.reusableCell)
    }
    
    init(networkService: NetworkManagerProtocol, lon: Double, lat: Double) {
        self.networkManager = networkService
        self.lon = lon
        self.lat = lat
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collection View Data Source

extension ForecastScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rows = dataSource.first?.daily.count {
            print("rows: \(rows)")
            return rows - 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reusableCell, for: indexPath) as! ForecastCollectionViewCell
        
        if let data = dataSource.first?.daily {
            let row = data[indexPath.row + 1]
            cell.configure(with: row)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

// MARK: - Collection View Delegate

extension ForecastScreenViewController: UICollectionViewDelegate {
    
}

// MARK: - Collection View Flow Layout Delegate

extension ForecastScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let height = width / 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Map View Extension
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 9_000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: false)
    }
}
