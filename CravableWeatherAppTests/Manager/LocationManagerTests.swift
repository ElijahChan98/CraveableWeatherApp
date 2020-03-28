//
//  LocationManagerTests.swift
//  CravableWeatherAppTests
//
//  Created by Elijah Tristan Huey Chan on 27/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import XCTest

class LocationManagerTests: XCTestCase {
    let locationManager = LocationManager()
    func testPerformSearchRequest(){
        let validSearchRequestExpectation = XCTestExpectation(description: "search returns locations")
        locationManager.performSearchRequest(searchText: "Manila") { (results) in
            if results.count > 0 {
                validSearchRequestExpectation.fulfill()
            }
            else {
                XCTFail("Manila did not return any search results")
            }
        }
        
        let invalidSearchRequestExpectation = XCTestExpectation(description: "search returns locations")
        locationManager.performSearchRequest(searchText: "-`123460=") { (results) in
            if results.count == 0 {
                invalidSearchRequestExpectation.fulfill()
            }
            else {
                XCTFail("invalid search did return search results")
            }
        }
        
        self.wait(for: [validSearchRequestExpectation, invalidSearchRequestExpectation], timeout: 10)
    }
    
    func testGetCity(){
        let validInputExpectation = XCTestExpectation(description: "returns valid location data from zipcode")
        locationManager.getCityFrom(input: "1015") { (address) in
            guard let _ = address else{
                XCTFail("did not find address from zipcode")
                return
            }
            validInputExpectation.fulfill()
        }
        
        let invalidInputExpectation = XCTestExpectation(description: "returns invalid location data from invalid input")
        locationManager.getCityFrom(input: "-=123`/") { (address) in
            guard let address = address, address == "-=123`/" else {
                XCTFail("found address from invalid input")
                return
            }
            invalidInputExpectation.fulfill()
        }
        
        self.wait(for: [validInputExpectation, invalidInputExpectation], timeout: 10)
    }
}
