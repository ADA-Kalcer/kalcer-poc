//
//  LocationManagerViewModel.swift
//  KalcerPOC
//
//  Created by Tude Maha on 14/08/2025.
//

import Foundation
import CoreLocation

class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:
            authorizationStatus = .restricted
            break
            
        case .denied:
            authorizationStatus = .denied
            break
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            break
            
        default:
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
}
