//
//  Weather.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 25/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

struct Weather{
    let temperature: Temperature
    let location: Location
    let wind: Wind
    
    let shortDescription: String
    let detailedDescription: String
    let visibility: Double
    
    let iconURL: URL?
    
    init(temperature: Temperature, location: Location, wind: Wind, shortDesc: String?, detailedDesc: String?, visibility: Double?, iconURL: URL? = nil) {
        self.temperature = temperature
        self.location = location
        self.wind = wind
        self.shortDescription = shortDesc ?? "unavailable"
        self.detailedDescription = detailedDesc ?? "unavailable"
        self.visibility = visibility ?? 0
        self.iconURL = iconURL
    }
}

struct Location {
    let longitude: Double
    let latitude: Double
    
    let city: String
    let country: String
    
    init(longitude: Double?, latitude: Double?, city: String?, country: String?) {
        self.latitude = latitude ?? 0
        self.longitude = longitude ?? 0
        self.city = city ?? "unavailable"
        self.country = country ?? "unavailable"
    }
}

struct Temperature {
    let currentTemperature: Double
    let heatIndex: Double
    
    let minTemperature: Double
    let maxTemperature: Double
    
    let pressure: Double
    let humidity: Double
    
    init(currentTemperature: Double?, heatIndex: Double?, minTemperature: Double?, maxTemperature: Double?, pressure: Double?, humidity: Double?) {
        self.currentTemperature = currentTemperature ?? 0
        self.heatIndex = heatIndex ?? 0
        self.minTemperature = minTemperature ?? 0
        self.maxTemperature = maxTemperature ?? 0
        self.pressure = pressure ?? 0
        self.humidity = humidity ?? 0
    }
}

struct Wind {
    let speed: Double
    let degrees: Double
    
    init(speed: Double?, degrees: Double?) {
        self.speed = speed ?? 0
        self.degrees = degrees ?? 0
    }
}





