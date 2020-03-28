//
//  SearchWeatherViewController.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 25/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class SearchWeatherViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var heatIndexLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var icocImage: UIImageView!
    
    var weather: Weather?
    let weatherManager = OpenWeatherManager()
    var filteredHistoryResults: [String] = []
    var filteredSearchResults: [String] = []
    let searchResultsTableViewController = SearchResultsTableViewController()
    var searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.getLocationPermission()
        setupSearchController()
        setupInitialWeather()
    }
    
    func setupInitialWeather() {
        if let latestCity = SearchHistory.shared.contents.first {
            updateWeather(city: latestCity)
        }
        else{
            NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .LocationReceived, object: nil)
        }
    }
    
    @objc private func locationDidUpdate(){
        NotificationCenter.default.removeObserver(self, name: .LocationReceived, object: nil)
        updateWeather(city: LocationManager.shared.city ?? "")
    }
    
    private func setupSearchController(){
        searchResultsTableViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search City or Zip Code"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func onSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let input = searchBar.text else {
            return
        }
        if input == Constants.USE_CURRENT_LOCATION {
            updateWeather(city: LocationManager.shared.city ?? "")
        }
        else{
            SearchHistory.shared.addToHistory(city: input)
            LocationManager.shared.getCityFrom(input: input) { (city) in
                self.updateWeather(city: city ?? input)
            }
        }
    }
    
    func updateWeather(city: String){
        weatherManager.getWeather(city: city) { (weather) in
            self.weather = weather
            DispatchQueue.main.async {
                self.updateViewLabels()
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        LocationManager.shared.performSearchRequest(searchText: searchText) { (results) in
            self.searchResultsTableViewController.searchResults = results
        }
        
        if searchController.isActive && isSearchBarEmpty {
            searchResultsTableViewController.searchHistoryResults = SearchHistory.shared.contents
            return
        }
        
        filteredHistoryResults = SearchHistory.shared.contents.filter({ (city) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        })
        searchResultsTableViewController.searchHistoryResults = self.filteredHistoryResults
    }
    
    func updateViewLabels() {
        downloadAndUpdateImageView()
        cityLabel.text = self.weather?.location.city ?? searchController.searchBar.text
        countryLabel.text = self.weather?.location.country ?? ""
        weatherDescriptionLabel.text = self.weather?.detailedDescription
        temperatureLabel.text = "\(self.weather?.temperature.currentTemperature ?? 0)˚C"
        heatIndexLabel.text = "\(self.weather?.temperature.heatIndex ?? 0)˚C"
        humidityLabel.text = "\(self.weather?.temperature.humidity ?? 0)%"
        windSpeedLabel.text = "\(self.weather?.wind.speed ?? 0)"
    }
    
    func downloadAndUpdateImageView() {
        guard let iconURL = self.weather?.iconURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: iconURL) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.icocImage.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

extension SearchWeatherViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.onSearchButtonClicked(searchBar)
        searchBar.text = ""
        searchController.isActive = false
    }
}

extension SearchWeatherViewController: SearchResultsTableViewControllerDelegate {
    func handleRowSelection(result: String) {
        self.searchController.searchBar.text = result
        searchBarSearchButtonClicked(self.searchController.searchBar)
    }
    
    func handleRowDeletion(deletedResult: String) {
        SearchHistory.shared.deleteHistory(city: deletedResult)
    }
}
