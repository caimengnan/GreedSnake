//
//  Speed.swift
//  贪吃蛇
//
//  Created by targeter on 2019/2/22.
//  Copyright © 2019 targeter. All rights reserved.
//

import Foundation
import UIKit

//积分每增长5个，速度增长0.05
class Speed {
    static let shared = Speed()
    var delegate:ScoreAndSpeedProtocol?
    //初始速度
    var initSpeed:CGFloat = 0.5
    
    //根据积分改变速度
    func addSpeed(_ score:Int) {
        initSpeed = initSpeed - CGFloat(score/score_speed) * baseSpeed
        delegate?.addSpeed()
    }
    
}
