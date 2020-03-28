//
//  SearchWeatherViewControllerTestPage.swift
//  CravableWeatherAppUITests
//
//  Created by Elijah Tristan Huey Chan on 28/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class SearchWeatherViewControllerTestPage: NSObject {
    let app = XCUIApplication()
    var searchField: XCUIElement {
        return app.searchFields["Search City or Zip Code"]
    }
    
    var searchButton: XCUIElement {
        return app.keyboards.buttons["Search"]
    }
}
