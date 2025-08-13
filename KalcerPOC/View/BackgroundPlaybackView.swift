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
        VStack(spacing: 10) {
            Button(viewModel.isPlaying ? "Pause" : "Play") {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play(url: URL(string: "https://storage.googleapis.com/random-cdn-tude/music-example.mp3")!)
                }
            }
            Text(viewModel.isOtherAudioPlaying ? "Other playing" : "No other playing")
            Text(String(viewModel.currentVolume))
        }
        .navigationTitle("Background Playback")
    }
}

#Preview {
    BackgroundPlaybackView()
}
