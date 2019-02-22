//
//  Protocol.swift
//  贪吃蛇
//
//  Created by targeter on 2019/2/22.
//  Copyright © 2019 targeter. All rights reserved.
//

import Foundation
import UIKit

protocol ScoreAndSpeedProtocol {
    func addScore(_ scroe: Int)
    func addSpeed()
}

//游动的时间
var timeSpace:TimeInterval = 0.3
//速度增长基数
let baseSpeed:CGFloat = 0.02
//积分-速度联动值
let score_speed = 5
