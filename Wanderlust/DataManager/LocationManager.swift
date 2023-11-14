//
//  LocationManager.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import Foundation
import CoreData
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    // Create an instance of CLLocationManager to manage location services.
    private var locationManager = CLLocationManager()
    //Published property to track the user's location
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        // Set the delegate of the locationManager to self (the LocationManager instance).
        self.locationManager.delegate = self
        // Request authorization to use location services when the app is in use.
        self.locationManager.requestWhenInUseAuthorization()
        // Start updating the user's location.
        //self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // called when there is a change in the authorization status for location services.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location authorization not determined")
        case .restricted:
            print("Location authorization restricted")
        case .denied:
            print("Location authorization denied")
        case .authorizedAlways:
            manager.requestLocation()
            print("Location authorization always granted")
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            print("Location authorization when in use granted")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    //called when the location manager receives new location data.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the userLocation property with the most recent location.
        if let location = locations.last {
            self.userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
