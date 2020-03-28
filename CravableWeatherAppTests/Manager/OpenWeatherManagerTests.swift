//
//  OpenWeatherManagerTests.swift
//  CravableWeatherAppTests
//
//  Created by Elijah Tristan Huey Chan on 27/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class OpenWeatherManagerTests: XCTestCase {
    let openWeatherManager = OpenWeatherManager()
    func testGetWeather(){
        let weatherValidExpectation = XCTestExpectation(description: "Manila call returns valid weather")
        openWeatherManager.getWeather(city: "Manila") { (weather) in
            guard let weather = weather, weather.location.city != "unavailable" else{
                XCTFail("Manila weather call failed")
                return
            }
            weatherValidExpectation.fulfill()
        }
        
        let cityWithSpaceExpectation = XCTestExpectation(description: "San Francisco call returns valid weather")
        openWeatherManager.getWeather(city: "San Francisco") { (weather) in
            guard let weather = weather, weather.location.city != "unavailable" else{
                XCTFail("City with space weather call failed")
                return
            }
            cityWithSpaceExpectation.fulfill()
        }
        
        let invalidCityExpectation = XCTestExpectation(description: "Invalid city does not return weather")
        openWeatherManager.getWeather(city: "ABCD1234()") { (weather) in
            guard let city = weather?.location.city, city != "unavailable" else{
                invalidCityExpectation.fulfill()
                return
            }
            XCTFail("Weather should be invalid")
        }
        
        self.wait(for: [weatherValidExpectation, cityWithSpaceExpectation, invalidCityExpectation], timeout: 10)
    }
    
}
