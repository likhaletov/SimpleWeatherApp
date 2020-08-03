//
//  SearchScreenViewController.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 22.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import MapKit

protocol SearchViewControllerDelegate: AnyObject {
    func didAddCity(placemark: MKPlacemark)
}

class SearchScreenViewController: UITableViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let mapKitCompleter: MapKitCompleterProtocol
    private var mapKitDataSource: [MKLocalSearchCompletion] = []
    
    private let citySearchController = UISearchController(searchResultsController: nil)
    private let citySearchBar: UISearchBar? = nil
    private let searchResultsTableViewReusableCell = "cell"
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        mapKitCompleter.updateDelegate = self
    }
    
    private func configureUI() {
        title = "Add new city"
        
        configureSearchAndBar()
        configureTableView()
        configureNavBar()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchResultsTableViewReusableCell)
    }
    
    private func configureNavBar() {
        if #available(iOS 13.0, *) {
            let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeHandler))
            navigationItem.rightBarButtonItem = closeBarButtonItem
        } else {
            let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeHandler))
            navigationItem.rightBarButtonItem = closeBarButtonItem
        }
        
    }
    
    @objc
    private func closeHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureSearchAndBar() {
        citySearchController.searchResultsUpdater = self
        citySearchController.obscuresBackgroundDuringPresentation = false
        citySearchController.hidesNavigationBarDuringPresentation = false
        
        let searchBar = citySearchController.searchBar
        searchBar.placeholder = "Search city"
        searchBar.showsCancelButton = true
        
        definesPresentationContext = true
        navigationItem.searchController = citySearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        mapKitCompleter.completer.queryFragment = searchBarText
        
        if searchBarText.isEmpty {
            mapKitCompleter.completer.cancel()
            mapKitDataSource.removeAll()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MapKitRequest.makeRequest(with: self.mapKitDataSource[indexPath.row].title) { [weak self] (place) in

            guard let self = self else { return }
            
            self.delegate?.didAddCity(placemark: place)
            
            if self.citySearchController.isActive {
                self.citySearchController.dismiss(animated: false, completion: nil)

                self.citySearchBar?.text = ""
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapKitDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchResultsTableViewReusableCell, for: indexPath)
        cell.textLabel?.text = mapKitDataSource[indexPath.row].title
        cell.detailTextLabel?.text = mapKitDataSource[indexPath.row].subtitle
        return cell
    }
    
    init(mapKitCompleter: MapKitCompleterProtocol) {
        self.mapKitCompleter = mapKitCompleter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - SearchResultsUpdate protocol; UPDATE results of table view
extension SearchScreenViewController: SearchResultsUpdate {
    
    func didSearchResultsUpdate(with array: [MKLocalSearchCompletion]) {
        self.mapKitDataSource = array
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            self.tableView.reloadData()
        })
    }
    
}

extension SearchScreenViewController: UISearchResultsUpdating {
    
}
