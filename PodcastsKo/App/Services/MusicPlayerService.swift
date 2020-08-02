//
//  MusicPlayerService.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/31/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import AVKit
import CoreMedia
import MediaPlayer

protocol AudioPlayerable {
    func setupAudioSession()
    func setupRemoteControl(commandCenterService: AudioCommandCenterServiceable)
    func setCurrent(url: URL)
    func seek(to value: Float)
    func moveTo(seconds: Int)
    func play()
    func pause()
    func volume(value: Float)
    func observeCurrentTime(observer: @escaping (PlayerStatusViewModel) -> Void)
}

protocol AudioCommandCenterServiceable: class {
    func pause()
    func play()
}

class MusicPlayerService: AudioPlayerable {
    
    //
    private weak var commandCenterService: AudioCommandCenterServiceable?
    
    let avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
   
    func setCurrent(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .init())
        } catch {
            print("Failed to activate session:", error)
        }
    }
    
    func setupRemoteControl(commandCenterService: AudioCommandCenterServiceable) {
        
        self.commandCenterService = commandCenterService
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        MPRemoteCommandCenter.shared().playCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            
            self?.commandCenterService?.play()
            
            return .success
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            
            self?.commandCenterService?.pause()
            
            return .success
        }
        
        // Command for airpods double tap
//        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true
//        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
//
//            self?.commandCenterService?.pause()
//
//            return .success
//        }
        
    }
    
    func play() {
        avPlayer.play()
    }
    
    func pause() {
        avPlayer.pause()
    }
    
    func seek(to value: Float) {
        guard let duration = self.avPlayer.currentItem?.duration else { return }
        
        let durationInSecs = CMTimeGetSeconds(duration)
        
        let seekTimeInSecs = Float64(value) * durationInSecs
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSecs, preferredTimescale: Int32(NSEC_PER_SEC))
        
        avPlayer.seek(to: seekTime)
    }
    
    func moveTo(seconds: Int) {
        
        let secondsToMove = CMTime(value: CMTimeValue(seconds), timescale: 1)
        let seekTime = CMTimeAdd(avPlayer.currentTime(), secondsToMove)
        
        avPlayer.seek(to: seekTime)
        
    }
    
    func volume(value: Float) {
        self.avPlayer.volume = value
    }
    
    func observeCurrentTime(observer: @escaping (PlayerStatusViewModel) -> Void) {
        let interval = CMTime(value: 1, timescale: 1)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            guard let self = self else { return }
            
//            let durationString = self.avPlayer.currentItem?.duration == nil ?
//                "--:--" : self.avPlayer.currentItem!.duration.getMinuteFormattedString()
            
            let durationTime = self.avPlayer.currentItem?.duration == nil ? CMTime(value: 1, timescale: 1) : self.avPlayer.currentItem!.duration
            
            let percentage = CMTimeGetSeconds(time) / CMTimeGetSeconds(durationTime)
            
            let status = PlayerStatusViewModel(currentSeconds: time.getTotalSeconds(), totalSeconds: durationTime.getTotalSeconds(), percentage: Float(percentage))
            
            observer(status)
        }
    }
    
}

struct PlayerStatusViewModel {
    
    let currentSeconds: Int
    let totalSeconds: Int
    let percentage: Float
    
    func getCurrentFormatted() -> String {
        let seconds = currentSeconds % 60
        let minutes = currentSeconds / 60
        
        let timeFormattedString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormattedString
    }
    
    func getDurationFormatted() -> String {
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        let timeFormattedString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormattedString
    }
    
}

extension CMTime {
    
    func getTotalSeconds() -> Int {
        if CMTimeGetSeconds(self).isNaN {
            return 0
        }
        
        return Int(CMTimeGetSeconds(self))
    }
    
    func getMinuteFormattedString() -> String {
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        let timeFormattedString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormattedString
    }
    
}
