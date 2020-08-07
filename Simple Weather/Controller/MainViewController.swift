//
//  MainScreenViewController.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 19.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = MainScreenView()
    lazy var forecastPresentationDelegate = ForecastTransition()
    
    // Presentation layer
    private var locationManager: LocationManagerProtocol
    private var networkManager: NetworkManagerProtocol
    private var persistentManager: PersistentManagerProtocol
    
    // Model
    var model: [WeatherModel] = [] {
        didSet {
            if !model.isEmpty {
                DispatchQueue.main.async {
                    self.editButtonItem.isEnabled = true
                }
            } else {
                DispatchQueue.main.async {
                    self.editButtonItem.isEnabled = false
                    self.mainView.weatherTableView.isEditing = false
                }
            }
        }
    }
    
    var userLocation: CLLocation? {
        didSet {
            if NetworkMonitor.shared.isConnected {
                refreshUserLocationWeather()
            }
        }
    }
    
    // MARK: - Load view
    override func loadView() {
        super.view = mainView
    }
    
    // MARK: - VC Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if model.isEmpty { editButtonItem.isEnabled = false }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        loadData()
        configureUI()
    }
    
    private func configureUI() {
        title = "Simple Weather"
        
        configureNavController()
        configureWeatherTableView()
    }
    
    private func configureWeatherTableView() {
        mainView.weatherTableView.delegate = self
        mainView.weatherTableView.dataSource = self
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            mainView.weatherTableView.setEditing(true, animated: true)
        } else {
            mainView.weatherTableView.setEditing(false, animated: true)
        }
    }
    
    private func configureNavController() {
        let editBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = editBarButtonItem
        
        let addCityBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemHandler))
        
        let toggleDegreesBarButtonItem: UIBarButtonItem = {
            var bbi = UIBarButtonItem()
            
            switch Settings.apiMetrics {
            case .imperial:
                bbi = UIBarButtonItem(title: Degrees.celsius, style: .plain, target: self, action: #selector(toggleDegrees))
                return bbi
            case .metric:
                bbi = UIBarButtonItem(title: Degrees.fahrenheit, style: .plain, target: self, action: #selector(toggleDegrees))
                return bbi
            }
        }()
        
        let separator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        navigationItem.rightBarButtonItems = [
            addCityBarButtonItem,
            separator,
            toggleDegreesBarButtonItem
        ]
    }
    
    @objc func toggleDegrees() {
        if Settings.metrics == Degrees.celsius {
            Settings.metrics = Degrees.fahrenheit
            Settings.apiMetrics = .imperial
            navigationItem.rightBarButtonItems?.last?.title = Degrees.celsius
            refreshUserLocationWeather()
            refreshWeather()
        } else {
            Settings.metrics = Degrees.celsius
            Settings.apiMetrics = .metric
            navigationItem.rightBarButtonItems?.last?.title = Degrees.fahrenheit
            refreshUserLocationWeather()
            refreshWeather()
        }
    }
    
    private func loadData() {
        let loadDataFromFile = persistentManager.loadData()
        
        loadDataFromFile.forEach { (item) in
            print(Thread.current)
            
            let loadedItem = WeatherModel(
                id: item.id,
                name: item.name,
                lat: item.lat,
                lon: item.lon,
                weather: item.weather,
                temperature: item.temperature,
                humidity: item.humidity
            )
            
            model.append(loadedItem)
            
        }
        
        refreshWeather()
    }
    
    private func refreshUserLocationWeather() {
        if NetworkMonitor.shared.isConnected {
            
            if CLLocationManager.locationServicesEnabled() {
                let lat = locationManager.getLat()
                let lon = locationManager.getLon()
                
                networkManager.obtain(from: URL.getAPI(lat: lat, lon: lon, units: Settings.apiMetrics), completion: { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let data):
                        let decoder = JSONDecoder()
                        
                        do {
                            let response = try decoder.decode(WeatherResponse.self, from: data)
                            guard let condition = response.weather.first?.main else { return }
                            
                            let string = """
                            \(response.name)
                            \(Condition.cases[condition] ?? "") \(String.roundDouble(number: response.main.temp)) \(Settings.metrics)
                            """
                            
                            DispatchQueue.main.async {
                                self.mainView.currentWeatherLabel.attributedText = AttributedStringFormatter.formatString(
                                    sourceString: string,
                                    fontSize: 25,
                                    color: .black
                                )
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
        } else {
            DispatchQueue.main.async {
                self.mainView.currentWeatherLabel.text = "No internet connection"
            }
        }
    }
    
    private func refreshWeather() {
        
        if model.isEmpty { return }
        
        let dispatchGroup = DispatchGroup()
        
        for (key, value) in model.enumerated() {
            
            dispatchGroup.enter()
            networkManager.obtain(from: URL.getAPI(id: value.id, units: Settings.apiMetrics), completion: { [weak self] (result) in
                
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let object = try decoder.decode(WeatherResponse.self, from: data)
                        self.model[key].temperature = object.main.temp
                        dispatchGroup.leave()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                }
                
            })
            
        }
        
        dispatchGroup.notify(queue: .main) {
            self.mainView.weatherTableView.reloadData()
            self.persistentManager.saveData(model: self.model)
        }
    }
    
    @objc
    private func addBarButtonItemHandler() {
        if NetworkMonitor.shared.isConnected {
            if let searchVC = ScreenAssembly.createSearchScreen() as? SearchScreenViewController {
                searchVC.delegate = self
                let nav = UINavigationController(rootViewController: searchVC)
                present(nav, animated: true, completion: nil)
            }
        } else {
            print("error: check your internet connection, please")
        }
    }
    
    // - Delegate method; Add new city
    func didAddCity(placemark: MKPlacemark) {
        
        let lat = placemark.coordinate.latitude
        let lon = placemark.coordinate.longitude
        
        let url = URL.getAPI(lat: lat, lon: lon, units: Settings.apiMetrics)
        
        networkManager.obtain(from: url, completion: { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(WeatherResponse.self, from: data)
                    
                    // check if city already exists
                    var flag = true
                    
                    self.model.forEach { (item) in
                        if item.id == response.id {
                            flag = false
                            return
                        }
                    }
                    
                    if flag {
                        
                        let newIndexPath = IndexPath(row: (self.model.count), section: 0)
                        
                        let newCity = WeatherModel(
                            id: response.id,
                            name: response.name,
                            lat: lat,
                            lon: lon,
                            weather: response.weather.first?.main ?? "",
                            temperature: response.main.temp,
                            humidity: response.main.humidity
                        )
                        
                        self.model.append(newCity)
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.mainView.weatherTableView.insertRows(at: [newIndexPath], with: .right)
                        }
                        
                        self.persistentManager.saveData(model: self.model)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                
                
            }
            
        })
    }
    
    init(
        locationManager: LocationManagerProtocol,
        networkManager: NetworkManagerProtocol,
        persistentManager: PersistentManagerProtocol
    ) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.persistentManager = persistentManager
        
        super.init(nibName: nil, bundle: nil)
        
        self.locationManager.coordinatesDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Update current user coordinates

extension MainScreenViewController: UpdateCurrentCoordinates {
    func didUpdateCoordinates(with coordinates: CLLocation) {
        userLocation = coordinates
    }
}

// MARK: - Table View Data Source

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            persistentManager.saveData(model: model)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.weatherTableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reusableCell, for: indexPath) as! WeatherTableViewCell
        let cellModel = model[indexPath.row]
        cell.configureCell(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = model[sourceIndexPath.row]
        model.remove(at: sourceIndexPath.row)
        model.insert(movedItem, at: destinationIndexPath.row)
        
        persistentManager.saveData(model: model)
    }
    
}

// MARK: - Table View Delegate

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lon = model[indexPath.row].lon
        let lat = model[indexPath.row].lat
        
        let forecastVC = ScreenAssembly.createForecastScreen(lon: lon, lat: lat)
        
        // custom transition
        forecastVC.transitioningDelegate = forecastPresentationDelegate
        forecastVC.modalPresentationStyle = .custom
        present(forecastVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Search View Controller Delegate

extension MainScreenViewController: SearchViewControllerDelegate {
    
}
