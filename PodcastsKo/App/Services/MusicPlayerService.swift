//
//  MusicPlayerService.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/31/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import AVKit

protocol AudioPlayerable {
    func setCurrent(url: URL)
    func play()
    func pause()
}

class MusicPlayerService: AudioPlayerable {
    
    let avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
   
    func setCurrent(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
    }
    
    func play() {
        avPlayer.play()
    }
    
    func pause() {
        avPlayer.pause()
    }
    
}
