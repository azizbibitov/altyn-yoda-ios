//
//  SoundPlayer.swift
//  Salam-beta
//
//  Created by Shirin on 29.06.2022.
//

import AVFoundation
import AudioToolbox

class SoundPlayer {
    static let shared = SoundPlayer()
    var player: AVAudioPlayer?

    private func play(url: URL, type: String) {
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: type)
            player?.volume = 1
            guard let player = player else { return }
            player.play()

        } catch let error {
            debugPrint("SoundPlayer error", error)
        }
    }

   
    func vibrate(){
        AudioServicesPlaySystemSound(1520)
    }

}
