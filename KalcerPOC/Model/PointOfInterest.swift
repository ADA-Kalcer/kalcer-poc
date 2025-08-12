//
//  PointOfInterest.swift
//  KalcerPOC
//
//  Created by Fuad Fajri on 12/08/25.
//

// MARK: - PointOfInterest.swift
// This is our Model. It's a simple struct to hold data about the locations
// we want to track. For this POC, we'll hardcode one statue.

import SwiftUI
import CoreLocation

struct PointOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let storyAudioFileName: String // e.g., "statue_story.mp3"
}
