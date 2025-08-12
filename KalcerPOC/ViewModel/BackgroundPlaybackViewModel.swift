//
//  BackgroundPlaybackViewModel.swift
//  KalcerPOC
//
//  Created by Tude Maha on 12/08/2025.
//

import Foundation
import AVFoundation

class BackgroundPlaybackViewModel: ObservableObject {
    //    remote audio play
    private var player: AVPlayer?
    
    //    local audio play
    private var localPlayer: AVAudioPlayer?
    
    @Published var isPlaying = false
    
    init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            /*
             category
             .playback make your music player act like music player in general, mute switch ignored
             .ambient make your music player volume follow the mute switch
             
             mode
             .mixWithOthers => mixed
             */
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    //        remote audio play
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        
        isPlaying = true
    }
    
    //        local audio play
    func play() {
        if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            print(path)
            print(url)
            
            do {
                localPlayer = try AVAudioPlayer(contentsOf: url)
                localPlayer?.play()
                
                isPlaying = true
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
    
    func pause() {
        player?.pause()
        localPlayer?.pause()
        isPlaying = false
    }
}
