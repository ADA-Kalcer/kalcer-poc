//
//  CoreLocationView.swift
//  KalcerPOC
//
//  Created by Tude Maha on 14/08/2025.
//

import SwiftUI

struct CoreLocationView: View {
    @StateObject private var locationManager = LocationManagerViewModel()

    
    var body: some View {
        VStack {
            Text(String(locationManager.latitude ?? 0))
            Text(String(locationManager.longitude ?? 0))
        }
    }
}

#Preview {
    CoreLocationView()
}
