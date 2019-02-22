//
//  ViewController.swift
//  贪吃蛇
//
//  Created by targeter on 2019/1/17.
//  Copyright © 2019 targeter. All rights reserved.
//

import UIKit
import AVFoundation

let kSCreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    //记速
    var moveSpeed = Speed.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(snakeView)
        self.view.addSubview(scoreView)
        
        let width:CGFloat = 50.0
        let height:CGFloat = 60.0
        
        self.upBtn.frame = CGRect(x: kSCreenWidth/2 - width/2, y: snakeView.frame.maxY + 30, width: width, height: height)
        
        self.downBtn.frame = CGRect(x: kSCreenWidth/2 - width/2, y: upBtn.frame.maxY + 50, width: width, height: height)
        
        self.leftBtn.frame = CGRect(x: kSCreenWidth/2 - height * 2.0, y: upBtn.frame.maxY, width: height, height: width)
        
        self.rightBtn.frame = CGRect(x: kSCreenWidth/2 + height, y: upBtn.frame.maxY, width: height, height: width)
        
        self.resetBtn.frame = CGRect(x: rightBtn.frame.minX, y: self.downBtn.frame.maxY + 30, width: height*2, height: width)
        
        self.startBtn.frame = CGRect(x: leftBtn.frame.maxX - height * 2, y: self.downBtn.frame.maxY + 30, width: height*2, height: width)
        
        self.view.addSubview(upBtn)
        self.view.addSubview(downBtn)
        self.view.addSubview(leftBtn)
        self.view.addSubview(rightBtn)
        self.view.addSubview(resetBtn)
        self.view.addSubview(startBtn)
        
        playBGM()
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        moveSpeed.delegate = self
    }
    
    //播放背景音乐
    func playBGM() {
        let path = Bundle.main.path(forResource: "bgm.mp3", ofType: nil)
        let sourceUrl = URL(fileURLWithPath: path!)
        playerItem = AVPlayerItem(url: sourceUrl)
        player = AVPlayer(playerItem: playerItem)
    }
    @objc func playbackFinished() {
        playBGM()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func moveChangeAction(sender:UIButton) {
        if sender.tag == 6 {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                snakeView.startAction()
                //打开背景音
                player?.play()
            } else {
                snakeView.stopAction()
                //关闭背景音
                player?.pause()
            }
        } else if sender.tag == 5 {
            snakeView.resetAction()
            startBtn.isSelected = false
        } else {
            snakeView.actionType = MoveDirectionType.typeFromString(tag: sender.tag)
            //添加音效
            MusicContrl.shared.changeDiretion()
        }
    }
    
    
    func showAlert() {
        //关闭背景音
        player?.pause()
        //添加死亡音效
        MusicContrl.shared.gameOver()
        let alertVC = UIAlertController(title: "提示", message:"哈哈，你死啦😝", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "重试", style: .cancel) { (action) in
            self.snakeView.resetAction()
            self.scoreView.scoreLabel.text = "0"
            self.scoreView.difficutyLabel.text = "1"
        }
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    lazy var snakeView:SnakeView = {
        let snakeView = SnakeView(frame: CGRect(x: 5, y: 40, width: kSCreenWidth*7/10, height: kSCreenWidth*7/10))
        snakeView.layer.cornerRadius = 4.0
        snakeView.layer.borderWidth = 1.0
        snakeView.layer.borderColor = UIColor.yellow.cgColor
        snakeView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        snakeView.delegate = self
        snakeView.callBack = { [weak self] in
            self?.snakeView.stopAction()
            self?.startBtn.isSelected = false
            self?.showAlert()
        }
        return snakeView
    }()
    
    lazy var scoreView:ScoreView = {
        let scoreView = ScoreView.loadScoreView()
        scoreView.frame = CGRect(x: snakeView.frame.maxX + 5, y: snakeView.frame.minY, width: kSCreenWidth - snakeView.frame.maxX - 10, height: snakeView.frame.size.height)
        scoreView.backgroundColor = .white
        return scoreView
    }()
    
    
    lazy var leftBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "zuobian"), for: .normal)
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var rightBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "youbian"), for: .normal)
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    lazy var upBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "shangbian"), for: .normal)
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 3
        return btn
    }()
    
    lazy var downBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "xiabian"), for: .normal)
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 4
        return btn
    }()
    
    lazy var resetBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("复位", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 5
        return btn
    }()
    
    lazy var startBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("开始", for: .normal)
        btn.setTitle("暂停", for: .selected)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(moveChangeAction), for: .touchUpInside)
        btn.tag = 6
        btn.backgroundColor = .yellow
        return btn
    }()


}

//添加积分的代理方法
extension ViewController:ScoreAndSpeedProtocol {
    func addScore(_ scroe: Int) {
        scoreView.scoreLabel.text = "\(scroe)"
    }
    
    func addSpeed() {
        //加速度，加难度
        snakeView.startAction()
        scoreView.addDiffculty()
    }
}

