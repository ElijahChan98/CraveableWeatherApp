//
//  OpenWeatherManager.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 25/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

struct Constants {
    public static let api = "5b82815504263392b6b6644f91a46da8"
    public static let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    public static let IMAGE_URL = "http://openweathermap.org/img/wn/"
    public static let USE_CURRENT_LOCATION = "Use Current Location"
}

struct OpenWeatherManager {
    func getWeather(city: String, completion: @escaping (Weather?) -> Void) {
        let session = URLSession.shared
        
        let originalString = "\(Constants.BASE_URL)?q=\(city)&units=metric&appid=\(Constants.api)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? originalString
        let requestURL = URL(string: urlString)!
        
        let task = session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error)
            }
            else if let data = data, let responseData = self.convertDataToDictionary(data: data) {
                completion(self.createWeatherData(responseData: responseData))
            }
        }
        task.resume()
    }
    
    func createWeatherData(responseData: [String: Any]) -> Weather {
        var weather: Weather!
        var temperature: Temperature!
        var location: Location!
        var wind: Wind!
        let visibility = responseData["visibility"] as? Double
        var iconUrl: URL?
        
        if let temperatureData = responseData["main"] as? [String: Any]{
            let maxTemp = temperatureData["temp_max"] as? Double
            let humidity = temperatureData["humidity"] as? Double
            let heatIndex = temperatureData["feels_like"] as? Double
            let minTemp = temperatureData["temp_min"] as? Double
            let temp = temperatureData["temp"] as? Double
            let pressure = temperatureData["pressure"] as? Double
            
            temperature = Temperature(currentTemperature: temp, heatIndex: heatIndex, minTemperature: minTemp, maxTemperature: maxTemp, pressure: pressure, humidity: humidity)
        }
        else {
            temperature = Temperature(currentTemperature: nil, heatIndex: nil, minTemperature: nil, maxTemperature: nil, pressure: nil, humidity: nil)
        }
        
        if let sysData = responseData["sys"] as? [String: Any], let coordinateData = responseData["coord"] as? [String: Any], let city = responseData["name"] as? String {
            let country = sysData["country"] as? String
            let longitude = coordinateData["lon"] as? Double
            let latitude = coordinateData["lat"] as? Double
            location = Location(longitude: longitude, latitude: latitude, city: city, country: country)
        }
        else {
            location = Location(longitude: nil, latitude: nil, city: nil, country: nil)
        }
        
        if let windData = responseData["wind"] as? [String: Any] {
            let speed = windData["speed"] as? Double
            let deg = windData["deg"] as? Double
            
            wind = Wind(speed: speed, degrees: deg)
        }
        else {
            wind = Wind(speed: nil, degrees: nil)
        }
        
        if let weatherData = responseData["weather"] as? [Any], let mainWeatherData = weatherData.first as? [String: Any] {
            let shortDesc = mainWeatherData["main"] as? String
            let detailedDesc = mainWeatherData["description"] as? String
            if let iconId = mainWeatherData["icon"] as? String{
                iconUrl = self.getWeatherIconURL(iconId: iconId)
            }
            
            weather = Weather(temperature: temperature, location: location, wind: wind, shortDesc: shortDesc, detailedDesc: detailedDesc, visibility: visibility, iconURL: iconUrl)
        }
        else {
            weather = Weather(temperature: temperature, location: location, wind: wind, shortDesc: nil, detailedDesc: nil, visibility: nil)
        }
        
        return weather
    }
    
    func getWeatherIconURL(iconId: String) -> URL {
        let originalString = "\(Constants.IMAGE_URL)\(iconId)@2x.png"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? originalString
        let requestURL = URL(string: urlString)!
        return requestURL
    }
    
    func convertDataToDictionary(data: Data) -> [String:Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            return json
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
