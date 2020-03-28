//
//  CitySearchHistory.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 26/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class SearchHistory: NSObject {
    private let SEARCH_HISTORY_KEY = "search_history"
    static let shared = SearchHistory()
    
    private(set) var contents: [String]{
        set {
            UserDefaults.standard.set(newValue, forKey: SEARCH_HISTORY_KEY)
        }
        get {
            guard let savedContents = UserDefaults.standard.value(forKey: SEARCH_HISTORY_KEY) as? [String] else {
                return []
            }
            return savedContents.reversed()
        }
    }
    
    public func addToHistory(city: String) {
        if city.count <= 0 {
            return
        }
        contents.removeAll { (existingCity) -> Bool in
            existingCity == city
        }
        contents.append(city)
    }
    
    public func deleteHistory(city: String) {
        if contents.contains(city) {
            contents.removeAll { (cityToDelete) -> Bool in
                city == cityToDelete
            }
        }
    }
}

