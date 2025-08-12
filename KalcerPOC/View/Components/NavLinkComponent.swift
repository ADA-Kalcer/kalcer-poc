//
//  NavLinkComponent.swift
//  KalcerPOC
//
//  Created by Tude Maha on 12/08/2025.
//

import SwiftUI

struct NavLinkComponent: View {
    let destination: any View
    let buttonTitle: String
    
    var body: some View {
        NavigationLink(destination: AnyView(destination)) {
            Text(buttonTitle)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavLinkComponent(destination: ExampleView(), buttonTitle: "Example")
}
