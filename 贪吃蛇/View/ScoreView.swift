//
//  ScoreView.swift
//  贪吃蛇
//
//  Created by targeter on 2019/2/22.
//  Copyright © 2019 targeter. All rights reserved.
//

import UIKit

class ScoreView: UIView {

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var difficutyLabel: UILabel!
    
    @IBOutlet weak var musicBtn: UIButton!
    
    static func loadScoreView() -> ScoreView {
        return Bundle.main.loadNibNamed("ScoreView", owner: self, options: nil)?.last as! ScoreView
    }
    
    
    func addDiffculty() {
        var dif = Int(difficutyLabel.text!)!
        dif+=1
        difficutyLabel.text = "\(dif)"
    }
    
    @IBAction func stopOrStartMusicAction(_ sender: UIButton) {
        
        
    }
}
