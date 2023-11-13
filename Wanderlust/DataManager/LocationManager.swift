//
//  LocationManager.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/6/23.
//

import Foundation
import CoreData
import CoreLocation

class LocationManager: NSObject {
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.activityType = CLActivityType.automotiveNavigation
        locationManager?.distanceFilter = kCLDistanceFilterNone
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.allowsBackgroundLocationUpdates = false
        locationManager?.pausesLocationUpdatesAutomatically = true
        locationManager?.delegate = self
        requestPersmission()
    }
    
    
    func requestPersmission() {
        let status = locationManager?.authorizationStatus
        if status == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
    }
    
    func checkForPermission() {
        if CLLocationManager.locationServicesEnabled() {
            
        }
    }
    
    func forceLocationUpdate() {
        locationManager?.requestLocation()
    }
    
    func startTrackingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager?.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count >= 1 {
            userLocation = locations[0]
            
            print(userLocation!.coordinate.latitude)
            print(userLocation!.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

