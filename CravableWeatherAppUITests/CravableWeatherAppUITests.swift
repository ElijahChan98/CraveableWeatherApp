//
//  CravableWeatherAppUITests.swift
//  CravableWeatherAppUITests
//
//  Created by Elijah Tristan Huey Chan on 25/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class CravableWeatherAppUITests: XCTestCase {
    let searchWeatherTestPage = SearchWeatherViewControllerTestPage()
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            let button = alert.buttons.element(boundBy: 1)
            if button.waitForExistence(timeout: 3) {
                button.tap()
            }
            return true
        }
        app.coordinate(withNormalizedOffset: CGVector.zero).tap()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchFunction(){
        searchWeatherTestPage.searchField.tap()
        searchWeatherTestPage.searchField.typeText("Quezon City")
        searchWeatherTestPage.searchButton.tap()
        
        XCTAssert(app.staticTexts["Quezon City"].exists)
        XCTAssert(app.staticTexts["PH"].exists)
    }

}
