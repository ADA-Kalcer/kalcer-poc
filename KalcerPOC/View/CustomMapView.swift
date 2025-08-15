//
//  CustomMapView.swift
//  KalcerPOC
//
//  Created by Tude Maha on 13/08/2025.
//

import SwiftUI
import MapKit

struct CustomMapView: View {
    @StateObject private var locationMgr = LocationManagerViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -8.65, longitude: 115.22),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    var body: some View {
        Map {
            Marker("Gatau di mana", coordinate: CLLocationCoordinate2D(latitude: -8.65, longitude: 115.22))
            Marker("Ini lokasi terkini", coordinate: CLLocationCoordinate2D(latitude: locationMgr.latitude ?? 0, longitude: locationMgr.longitude ?? 0))
            
            Annotation("Ini annotation", coordinate: CLLocationCoordinate2D(latitude: -8.61, longitude: 115.20)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.yellow)
                    Text("🛝")
                        .padding(5)
                }
            }
            
            MapCircle(center: region.center, radius: 1000)
                .foregroundStyle(.red.opacity(0.3))
                .stroke(.red, lineWidth: 2)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    init() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: locationMgr.latitude ?? 0, longitude: locationMgr.longitude ?? 0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
    }
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    
    static let example = Location(coordinate: CLLocationCoordinate2D(latitude: -8.65, longitude: 115.22))
}

#Preview {
    CustomMapView()
}
