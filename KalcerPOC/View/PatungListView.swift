//
//  PatungListView.swift
//  KalcerPOC
//
//  Created by Gede Pramananda Kusuma Wisesa on 12/08/25.
//

import SwiftUI

struct PatungListView: View {
    @StateObject private var patungViewModel = PatungViewModel()
    var body: some View {
        NavigationStack {
            if patungViewModel.isLoading {
                // Loading View
            } else {
                if patungViewModel.isError == nil {
                    if patungViewModel.patungs.isEmpty {
                        VStack {
                            Text("Patung is Empty")
                            Image(systemName: "person.circle")
                            Text("There are no patung found.")
                        }
                    } else {
                        List {
                            ForEach(patungViewModel.patungs) { patung in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: patung.image ?? "")) { image
                                        in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(patung.name)
                                            .font(.headline)
                                        Text(patung.description ?? "No description")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .navigationTitle("All Patungs")
                    }
                } else {
                    VStack {
                        Text("Something went wrong!")
                        Image(systemName: "exclamationmark.icloud")
                        Text(patungViewModel.isError?.description ?? "")
                    }
                    .navigationTitle("All Patungs")
                }
            }
        }
        .onAppear {
            Task {
                try await patungViewModel.getPatungs()
            }
        }
    }
    
}

#Preview {
    SupabaseTestView()
}
