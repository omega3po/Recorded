//
//  PlayerViewModel.swift
//  Recorded
//
//  Created by Sunny Hwang on 12/21/23.
//

import Foundation
import AVFoundation

let url = URL(fileURLWithPath: Bundle.main.path(forResource: "bm1", ofType: "mp3")!)

class PlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var player: AVAudioPlayer = try! AVAudioPlayer(contentsOf: url)
    
    func Play() {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        
        isPlaying = player.isPlaying
    }
    
    func GetCurrentTime(a: TimeInterval) -> String {
        let timeValue = Double(a)
        return String(ceil(timeValue))
    }
    
    func UpdateTimer() {
        isPlaying = player.isPlaying
    }
}
