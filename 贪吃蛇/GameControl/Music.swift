//
//  MusicControl.swift
//  贪吃蛇
//
//  Created by targeter on 2019/2/21.
//  Copyright © 2019 targeter. All rights reserved.
//

import Foundation
import AVFoundation

enum MusicType: String {
    case directionChange = "direction.mp3"
    case eatFood = "eat_food.mp3"
    case dead = "dead.mp3"
    case bgm = "bgm.mp3"
}


class MusicContrl {
    static let shared = MusicContrl()
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var musicType:MusicType? {
        didSet {
            playMusic(music: (musicType?.rawValue)!)
        }
    }
    
    //改变方向
    func changeDiretion() {
        musicType = .directionChange
    }
    
    //吃到食物
    func eatFood() {
        musicType = .eatFood
    }
    
    //死了
    func gameOver() {
        musicType = .dead
    }
    
    //背景音乐
    func backgroundMusic() {
        musicType = .bgm
    }
    
    //播放音效
    fileprivate func playMusic(music:String) {
        let path = Bundle.main.path(forResource: music, ofType: nil)
        let sourceUrl = URL(fileURLWithPath: path!)
        playerItem = AVPlayerItem(url: sourceUrl)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
}
