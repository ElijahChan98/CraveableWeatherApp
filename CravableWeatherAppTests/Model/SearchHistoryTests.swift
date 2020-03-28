//
//  SearchHistoryTests.swift
//  CravableWeatherAppTests
//
//  Created by Elijah Tristan Huey Chan on 28/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class SearchHistoryTests: XCTestCase {
    let searchHistory = SearchHistory()
    func testAddToHistory() {
        searchHistory.addToHistory(city: "test city")
        XCTAssert(searchHistory.contents.contains("test city"), "test city successfully added")
        
        searchHistory.addToHistory(city: "test city")
        let occurenceCount = searchHistory.contents.filter{$0 == "test city"}.count
        XCTAssert(occurenceCount == 1, "test city duplicate not added")
    }
    
    func testDeleteHistory(){
        searchHistory.deleteHistory(city: "test city")
        XCTAssert(!searchHistory.contents.contains("test city"), "test city successfully deleted")
    }
}
