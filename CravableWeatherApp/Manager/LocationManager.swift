//
//  LocationManager.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 26/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension Notification.Name {
    static let LocationReceived = Notification.Name("locationReceived")
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    private(set) var address: [AnyHashable?: Any]? {
        didSet {
            NotificationCenter.default.post(name: .LocationReceived, object: nil)
        }
    }
    var city: String? {
        get {
            return address?["City"] as? String
        }
    }
    
    func getLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let e = error {
                print(e)
            } else {
                guard let placeMark = placemarks?.first else {
                    return
                }
                guard let address = placeMark.addressDictionary else {
                    return
                }
                self.address = address
            }
        }
    }
    
    func performSearchRequest(searchText: String, completion: @escaping (_ results: [String]) -> ()) {
        CLGeocoder().geocodeAddressString(searchText) { (placemarks, error) in
            if let error = error {
                print(error)
            }
            guard let placemarks = placemarks else{
                completion([])
                return
            }
            let results = placemarks.map({
                [$0.subLocality, $0.locality, $0.administrativeArea, $0.country, $0.postalCode].compactMap { $0 }
                    .joined(separator: ", ")
            })
            completion(results)
        }
    }
    
    func getCityFrom(input: String, completion: @escaping (String?) -> ()) {
        CLGeocoder().geocodeAddressString(input) { (placemarks, error) in
            if let error = error {
                print(error)
                completion(input)
            }
            guard let placeMark = placemarks?.first else {
                return
            }
            let formattedAddress = [placeMark.locality, placeMark.country].compactMap { $0 }
                .joined(separator: ",")
            completion(formattedAddress)
        }
    }
}
