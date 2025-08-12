//
//  GeoPushView.swift
//  KalcerPOC
//
//  Created by Fuad Fajri on 12/08/25.
//

// MARK: - GeoPushView.swift
// This is our View. It's responsible for displaying the UI and sending user
// actions (like button taps) to the ViewModel.

import SwiftUI


struct GeoPushView: View {

// Create an instance of our ViewModel. @StateObject ensures it lives
// for the entire lifecycle of the view.
@StateObject private var viewModel = LocationViewModel()

var body: some View {
    VStack(spacing: 20) {
        Text("Geo-Notification POC")
            .font(.largeTitle)
            .fontWeight(.bold)

        Spacer()
        
        // Status icon
        Image(systemName: viewModel.isTracking ? "location.fill" : "location.slash.fill")
            .font(.system(size: 80))
            .foregroundColor(viewModel.isTracking ? .green : .gray)
        
        // Status message from the ViewModel
        Text(viewModel.statusMessage)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        
        Spacer()
        
        // The main control button
        Button(action: {
            viewModel.toggleTracking()
        }) {
            Text(viewModel.isTracking ? "Stop Tracking" : "Start Tracking")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isTracking ? Color.red : Color.blue)
                .cornerRadius(15)
                .shadow(radius: 5)
        }
        .padding(.horizontal, 40)

    }
    .padding(.vertical, 40)
    .onAppear {
        // When the view first appears, request the necessary permissions.
        viewModel.requestPermissions()
    }
}
}
