//
//  ViewController.swift
//  贪吃蛇
//
//  Created by targeter on 2019/1/17.
//  Copyright © 2019 targeter. All rights reserved.
//

import UIKit

let kSCreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(snakeView)
        
        let width:CGFloat = 50.0
        let height:CGFloat = 60.0
        
        self.upBtn.frame = CGRect(x: kSCreenWidth/2 - width/2, y: snakeView.frame.maxY + 30, width: width, height: height)
        
        self.downBtn.frame = CGRect(x: kSCreenWidth/2 - width/2, y: upBtn.frame.maxY + 50, width: width, height: height)
        
        self.leftBtn.frame = CGRect(x: kSCreenWidth/2 - height * 2.0, y: upBtn.frame.maxY, width: height, height: width)
        
        self.rightBtn.frame = CGRect(x: kSCreenWidth/2 + height, y: upBtn.frame.maxY, width: height, height: width)
        
        self.resetBtn.frame = CGRect(x: rightBtn.frame.minX, y: self.downBtn.frame.maxY + 50, width: height*2, height: width)
        
        self.startBtn.frame = CGRect(x: leftBtn.frame.maxX - height * 2, y: self.downBtn.frame.maxY + 50, width: height*2, height: width)
        
        self.view.addSubview(upBtn)
        self.view.addSubview(downBtn)
        self.view.addSubview(leftBtn)
        self.view.addSubview(rightBtn)
        self.view.addSubview(resetBtn)
        self.view.addSubview(startBtn)
        
    }
    
    @objc func moveChangeAction(sender:UIButton) {
        if sender.tag == 6 {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                snakeView.startAction()
            } else {
                snakeView.stopAction()
            }
        } else if sender.tag == 5 {
            snakeView.resetAction()
            startBtn.isSelected = false
        } else {
            snakeView.actionType = MoveDirectionType.typeFromString(tag: sender.tag)
        }
    }
    
    
    func showAlert() {
        let alertVC = UIAlertController(title: "提示", message:"哈哈，你死啦😝", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "重试", style: .cancel) { (action) in
            self.snakeView.resetAction()
        }
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    lazy var snakeView:SnakeView = {
        let snakeView = SnakeView(frame: CGRect(x: 10, y: 20, width: kSCreenWidth - 20, height: kSCreenWidth - 20))
        snakeView.layer.cornerRadius = 4.0
        snakeView.layer.borderWidth = 1.0
        snakeView.layer.borderColor = UIColor.red.cgColor
        snakeView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        
        snakeView.callBack = { [weak self] in
            self?.snakeView.stopAction()
            self?.startBtn.isSelected = false
            self?.showAlert()
        }
        
        return snakeView
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

