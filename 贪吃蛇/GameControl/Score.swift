//
//  Score.swift
//  贪吃蛇
//
//  Created by targeter on 2019/2/22.
//  Copyright © 2019 targeter. All rights reserved.
//

import Foundation
class Score {
    static let shared = Score()
    var score:Int = 0
    let speed = Speed.shared
    
    //改变积分
    func changeScore() -> Int {
        score+=1
        checkScore(score)
        return score
    }
    
    //检查积分
    func checkScore(_ score:Int) {
        if score % score_speed == 0 {
            speed.addSpeed(score)
        }
    }
    
}
