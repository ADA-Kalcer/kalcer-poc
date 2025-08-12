//
//  BackgroundPlaybackView.swift
//  KalcerPOC
//
//  Created by Tude Maha on 12/08/2025.
//

import SwiftUI

struct BackgroundPlaybackView: View {
    @StateObject var viewModel = BackgroundPlaybackViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.isPlaying ? "Pause" : "Play") {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play(url: URL(string: "https://storage.googleapis.com/random-cdn-tude/music-example.mp3")!)
                }
            }
        }
        .navigationTitle("Background Playback")
    }
}

#Preview {
    BackgroundPlaybackView()
}
