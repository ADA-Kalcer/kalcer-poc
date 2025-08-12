//
//  HomeView.swift
//  KalcerPOC
//
//  Created by Tude Maha on 12/08/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavLinkComponent(destination: ExampleView(), buttonTitle: "Example")
                NavLinkComponent(destination: GeoPushView(), buttonTitle: "GeoPush")

                
                Spacer()
            }
            .navigationTitle("POC List")
        }
    }
}

#Preview {
    HomeView()
}
