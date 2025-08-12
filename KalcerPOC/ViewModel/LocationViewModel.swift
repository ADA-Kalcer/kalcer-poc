//
//  LocationViewModel.swift
//  KalcerPOC
//
//  Created by Fuad Fajri on 12/08/25.
//

// MARK: - LocationViewModel.swift
// This is the ViewModel. It contains all the business logic for location tracking,
// geofencing, permissions, notifications, and audio playback. It communicates
// changes to the View using @Published properties.

import SwiftUI
import CoreLocation
import AVFoundation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // A hardcoded point of interest for our POC.
    // Let's use the "Statue of Liberty" as an example.
    // You can change these coordinates to any location you want to test.
    let statue = PointOfInterest(
        name: "Statue of Liberty",
        coordinate: CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445),
        storyAudioFileName: "statue_story.mp3" // The full filename is now needed.
    )

    // Properties published to the View
    @Published var isTracking = false
    @Published var statusMessage = "Press 'Start' to begin tracking."
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    // MARK: - Initialization

    override init() {
        super.init()
        locationManager.delegate = self
        // For this POC, we want high accuracy to get frequent updates.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // This allows the app to receive location updates when it's in the background.
        locationManager.allowsBackgroundLocationUpdates = true
    }

    // MARK: - Permission Handling

    func requestPermissions() {
        // 1. Request Notification Permissions (including sound)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }

        // 2. Request Location Permissions
        // We need "Always" authorization for geofencing to work when the app is not running.
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - Core Logic

    func toggleTracking() {
        isTracking.toggle()
        if isTracking {
            startMonitoring()
        } else {
            stopMonitoring()
        }
    }

    private func startMonitoring() {
        // Ensure location services are enabled on the device.
        guard CLLocationManager.locationServicesEnabled() else {
            statusMessage = "Location services are disabled. Please enable them in Settings."
            isTracking = false
            return
        }
        
        // Ensure we have the necessary authorization.
        guard authorizationStatus == .authorizedAlways else {
            statusMessage = "App needs 'Always' location access. Please grant it in Settings."
            isTracking = false
            return
        }

        print("Starting to monitor location.")
        statusMessage = "Tracking location... Looking for '\(statue.name)'."

        // Create a geofence region.
        let region = CLCircularRegion(
            center: statue.coordinate,
            radius: 50.0, // 50 meters
            identifier: statue.id.uuidString
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false // We only care when the user enters.

        // Start monitoring the geofence.
        locationManager.startMonitoring(for: region)
        // Start getting heading updates to determine direction.
        locationManager.startUpdatingHeading()
    }

    private func stopMonitoring() {
        print("Stopping location monitoring.")
        statusMessage = "Tracking stopped. Press 'Start' to begin again."

        // Stop monitoring all regions.
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        locationManager.stopUpdatingHeading()
    }
    
    // MARK: - CLLocationManagerDelegate Methods

    // This delegate method is called when the app's authorization status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        // If the user grants permission while the app is running, we might want to auto-start tracking.
        if manager.authorizationStatus == .authorizedAlways && isTracking {
            startMonitoring()
        }
    }

    // THIS IS THE KEY METHOD! It's called when the user's device enters the geofenced region.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region: \(region.identifier)")
        
        // Make sure we have the user's current location and heading to calculate direction.
        guard let userLocation = manager.location, let userHeading = manager.heading else {
            sendNotification(title: "Statue Nearby!", body: "You've arrived at \(statue.name).", soundFileName: statue.storyAudioFileName)
            return
        }
        
        // Calculate directions
        let directions = calculateDirections(from: userLocation, heading: userHeading.trueHeading, to: statue.coordinate)
        
        let notificationBody = "The \(statue.name) is \(directions.relative) of you (\(directions.cardinal))."
        
        sendNotification(title: "Look Out!", body: notificationBody, soundFileName: statue.storyAudioFileName)
    }

    // Handle any errors.
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Geofencing monitoring failed with error: \(error.localizedDescription)")
        statusMessage = "Error: Could not monitor location."
    }

    // MARK: - Helper Methods

    // **FIX:** This function now attaches the sound directly to the notification.
    private func sendNotification(title: String, body: String, soundFileName: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        // Create a sound object from the file in the app bundle.
        // This is the most reliable way to play sound from the background.
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundFileName))

        // Fire the notification immediately.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification with custom sound scheduled successfully.")
            }
        }
    }
    
    private func calculateDirections(from userLocation: CLLocation, heading: CLLocationDirection, to destinationCoordinate: CLLocationCoordinate2D) -> (relative: String, cardinal: String) {
        
        let lat1 = userLocation.coordinate.latitude.degreesToRadians
        let lon1 = userLocation.coordinate.longitude.degreesToRadians
        
        let lat2 = destinationCoordinate.latitude.degreesToRadians
        let lon2 = destinationCoordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let bearingDegrees = atan2(y, x).radiansToDegrees
        
        // Normalize bearing to 0-360
        let bearing = (bearingDegrees + 360).truncatingRemainder(dividingBy: 360)
        
        // Cardinal Direction
        let cardinals = ["North", "Northeast", "East", "Southeast", "South", "Southwest", "West", "Northwest", "North"]
        let cardinalDirection = cardinals[Int(round(bearing / 45.0))]
        
        // Relative Direction
        var angleDifference = bearing - heading
        if angleDifference < -180 { angleDifference += 360 }
        if angleDifference > 180 { angleDifference -= 360 }
        
        let relativeDirection: String
        if angleDifference > -45 && angleDifference <= 45 {
            relativeDirection = "in front"
        } else if angleDifference > 45 && angleDifference <= 135 {
            relativeDirection = "to your right"
        } else if angleDifference < -45 && angleDifference >= -135 {
            relativeDirection = "to your left"
        } else {
            relativeDirection = "behind"
        }
        
        return (relativeDirection, cardinalDirection)
    }
}

// MARK: - Extensions for Direction Calculation
extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}

