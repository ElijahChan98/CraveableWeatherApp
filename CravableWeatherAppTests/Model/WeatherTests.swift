//
//  WeatherTest.swift
//  CravableWeatherAppTests
//
//  Created by Elijah Tristan Huey Chan on 27/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class WeatherTests: XCTestCase {
    func testInitializations(){
        var location: Location!
        var temperature: Temperature!
        var wind: Wind!
        var weather: Weather!
        
        let locationExpectation = XCTestExpectation(description: "weather was initialized properly")
        location = Location(longitude: 1, latitude: 1, city: "city", country: "country")
        if location.longitude == 1, location.latitude == 1, location.city == "city", location.country == "country" {
            locationExpectation.fulfill()
        }
        else {
            XCTFail("weather was not initialized properly")
        }
        
        let temperatureExpectation = XCTestExpectation(description: "temp was initialized properly")
        temperature = Temperature(currentTemperature: 1, heatIndex: 2, minTemperature: 3, maxTemperature: 4, pressure: 50, humidity: 60)
        if temperature.currentTemperature == 1, temperature.heatIndex == 2, temperature.minTemperature == 3, temperature.maxTemperature == 4, temperature.pressure == 50, temperature.humidity == 60{
            temperatureExpectation.fulfill()
        }
        else {
            XCTFail("temp was not initialized properly")
        }
        
        let windExpectation = XCTestExpectation(description: "wind was initialized properly")
        wind = Wind(speed: 1, degrees: 2)
        if wind.speed == 1, wind.degrees == 2 {
            windExpectation.fulfill()
        }
        else {
            XCTFail("wind was not initialized properly")
        }
        
        let weatherExpectation = XCTestExpectation(description: "weather was initialized properly")
        weather = Weather(temperature: temperature, location: location, wind: wind, shortDesc: "short", detailedDesc: "detailed", visibility: 10, iconURL: URL(string: "10d"))
        if weather.temperature.currentTemperature == temperature.currentTemperature, weather.location.city == location.city, weather.wind.speed == wind.speed, weather.shortDescription == "short", weather.detailedDescription == "detailed", weather.visibility == 10, weather.iconURL == URL(string: "10d"){
            weatherExpectation.fulfill()
        }
        else {
            XCTFail("wind was not initialized properly")
        }
    }
    
    func testEmptyInitializations(){
        var location: Location!
        var temperature: Temperature!
        var wind: Wind!
        var weather: Weather!
        
        let emptyLocationExpectation = XCTestExpectation(description: "weather was initialized properly")
        location = Location(longitude: nil, latitude: nil, city: nil, country: nil)
        if location.longitude == 0, location.latitude == 0, location.city == "unavailable", location.country == "unavailable" {
            emptyLocationExpectation.fulfill()
        }
        else {
            XCTFail("weather was not initialized properly")
        }
        
        let emptyTemperatureExpectation = XCTestExpectation(description: "temp was initialized properly")
        temperature = Temperature(currentTemperature: nil, heatIndex: nil, minTemperature: nil, maxTemperature: nil, pressure: nil, humidity: nil)
        if temperature.currentTemperature == 0, temperature.heatIndex == 0, temperature.minTemperature == 0, temperature.maxTemperature == 0, temperature.pressure == 0, temperature.humidity == 0{
            emptyTemperatureExpectation.fulfill()
        }
        else {
            XCTFail("temp was not initialized properly")
        }
        
        let emptyWindExpectation = XCTestExpectation(description: "wind was initialized properly")
        wind = Wind(speed: nil, degrees: nil)
        if wind.speed == 0, wind.degrees == 0 {
            emptyWindExpectation.fulfill()
        }
        else {
            XCTFail("wind was not initialized properly")
        }
        
        let emptyWeatherExpectation = XCTestExpectation(description: "weather was initialized properly")
        weather = Weather(temperature: temperature, location: location, wind: wind, shortDesc: nil, detailedDesc: nil, visibility: nil, iconURL: nil)
        if weather.temperature.currentTemperature == temperature.currentTemperature, weather.location.city == location.city, weather.wind.speed == wind.speed, weather.shortDescription == "unavailable", weather.detailedDescription == "unavailable", weather.visibility == 0, weather.iconURL == nil{
            emptyWeatherExpectation.fulfill()
        }
        else {
            XCTFail("wind was not initialized properly")
        }
    }
}
