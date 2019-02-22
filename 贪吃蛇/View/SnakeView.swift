//
//  SnakeView.swift
//  贪吃蛇
//
//  Created by targeter on 2019/1/17.
//  Copyright © 2019 targeter. All rights reserved.
//

import UIKit


enum MoveDirectionType {
    case NONE
    case UP
    case DOWN
    case LEFT
    case RIGHT
    case RESET
    case START
    case STOP
}

extension MoveDirectionType {
    static func typeFromString(tag: Int) -> MoveDirectionType {
        switch tag {
        case 1:
            return .LEFT
        case 2:
            return .RIGHT
        case 3:
            return .UP
        case 4:
            return .DOWN
        case 5:
            return .RESET
        case 6:
            return .START
        default:
            return .STOP
        }
    }
}

//单位长度
let eachPointWidth:CGFloat = 10.0
//单位长度的一半
let halfEachPointWidth:CGFloat = eachPointWidth/2

class SnakeView: UIView {
    //死亡回调
    var callBack:(()->())?
    //初始值
    var actionType = MoveDirectionType.RIGHT
    var randomPoint = CGPoint.zero
    var eatOrNot = false
    var isDead = false
    
    //蛇身的颜色
    let snakeColor = UIColor.red
    //蛇头的颜色
    let snakeHeadColor = UIColor.black
    //初始位置
    var point1 = CGPoint(x: 195.0, y: 165.0)
    var point2 = CGPoint(x: 205.0, y: 165.0)
    var timer = Timer.init()
    
    //存储中心点
    var breakPointArray = [CGPoint]()
    //记录方向改变之前的值
    var forwardDierct = MoveDirectionType.RIGHT
    //计分
    var delegate:ScoreAndSpeedProtocol?
    //记速
    var moveSpeed = Speed.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        breakPointArray.append(point1)
        breakPointArray.append(point2)
        self.addSubview(point)
        //创建随机点
        createRandomPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:绘图
    override func draw(_ rect: CGRect) {
        //绘制网格
        drawGridding()
        //画蛇
        drawSnake()
    }
    
    //画蛇
    func drawSnake() {
        for i in 0..<breakPointArray.count {
            if breakPointArray[i] == breakPointArray.last {
                //头
                snakeHead(center: breakPointArray[i])
            }
            else {
                //身
                findfourPointsAndconnect(centerPoint: breakPointArray[i])
            }
        }
    }
    
    //画蛇头
    func snakeHead(center:CGPoint){
        snakeColor.set()
        let path = UIBezierPath()
        //起始点
        var startAngle:CGFloat = 0
        //结束点
        var endAngle:CGFloat = 0
        switch actionType {
        case .RIGHT:
            startAngle = CGFloat.pi * 11 / 6
            endAngle = CGFloat.pi / 6
        case .LEFT:
            startAngle = CGFloat.pi * 5 / 6
            endAngle = CGFloat.pi * 7 / 6
        case .UP:
            startAngle = CGFloat.pi * 4 / 3
            endAngle = CGFloat.pi * 5 / 3
        case .DOWN:
            startAngle = CGFloat.pi / 3
            endAngle = CGFloat.pi * 2 / 3
        default:
            break
        }
        path.addArc(withCenter: center, radius: 5.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        path.lineWidth = 1.0
        path.close()
        path.fill()
    }
    
    ///滑动
    @objc func snakeAction() {
        //方向相反的操作不响应
        if (forwardDierct == .RIGHT && actionType == .LEFT) || (forwardDierct == .LEFT && actionType == .RIGHT) || (forwardDierct == .UP && actionType == .DOWN) || (forwardDierct == .DOWN && actionType == .UP) {
            actionType = forwardDierct
        } else {
            forwardDierct = actionType
        }
        switch actionType {
        case .UP,.DOWN,.LEFT,.RIGHT:
            moveDirectionChangeTo(moveType: actionType)
        case .RESET:
            resetAction()
        case .START:
            start()
        default:
            stopAction()
        }
        self.setNeedsDisplay()
        //是否碰壁死亡(包括碰到自己)
        snakeIsDeadOrNot()
    }
    
    ///是否碰壁死亡
    func snakeIsDeadOrNot() {
        //是否碰壁死亡
        let lastPoint = breakPointArray.last ?? CGPoint.zero
        let hitSelf = containsDuplicate(breakPointArray)
        if hitSelf {
            callBack?()
            return
        }
        //边沿点
        let lastPoint_x_left = lastPoint.x - halfEachPointWidth
        let lastPoint_x_right = lastPoint.x + halfEachPointWidth
        let lastpoint_y_up = lastPoint.y - halfEachPointWidth
        let lastPoint_y_down = lastPoint.y + halfEachPointWidth
        switch actionType {
        case .UP:
            if lastpoint_y_up < 0 {
                callBack?()
            }
        case .DOWN:
            if lastPoint_y_down > self.bounds.size.height {
                callBack?()
            }
        case .RIGHT:
            if lastPoint_x_right > self.bounds.size.width {
                callBack?()
            }
        case .LEFT:
            if lastPoint_x_left < 0 {
                callBack?()
            }
        default:
            break
        }
    }
    
    ///蛇是否吃到食物
    func snakeEatFood() {
        if point.center == breakPointArray.last {
            //吃到食物，创建随机点
            createRandomPoint()
            //添加音效
            MusicContrl.shared.eatFood()
            //添加积分
            let score = Score.shared.changeScore()
            delegate?.addScore(score)
        } else {
            //没吃到食物，继续
            breakPointArray.remove(at: 0)
        }
    }
    
    
    //根据中心点找到四个角的点并连接起来
    func findfourPointsAndconnect(centerPoint:CGPoint) {
        snakeColor.set()
        let path = UIBezierPath()
        path.addArc(withCenter: centerPoint, radius: halfEachPointWidth, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = 1.0
        path.fill()
    }
    
    ///开始
    func startAction() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(moveSpeed.initSpeed), target: self, selector: #selector(snakeAction), userInfo: nil, repeats: true)
        print("当前速度：\(moveSpeed.initSpeed)")
        startTimer()
    }
    
    ///初始开始
    func start() {
        moveDirectionChangeTo(moveType: .RIGHT)
    }
    
    ///暂停
    func stopAction() {
        stopTimer()
    }
    
    ///复位
    func resetAction() {
        stopTimer()
        breakPointArray.removeAll()
        breakPointArray.append(point1)
        breakPointArray.append(point2)
        self.setNeedsDisplay()
        actionType = .RIGHT
        forwardDierct = .RIGHT
        Speed.shared.initSpeed = 0.5
        Score.shared.score = 0
    }
    
    ///方向操作
    func moveDirectionChangeTo(moveType:MoveDirectionType) {
        //找到最后一个点
        let lastPoint = breakPointArray.last
        //根据最后一个点找到其上面的点
        var upPoint = CGPoint.zero
        switch moveType {
        case .UP:
            upPoint.x = (lastPoint?.x)!
            upPoint.y = (lastPoint?.y)! - eachPointWidth
        case .DOWN:
            upPoint.x = (lastPoint?.x)!
            upPoint.y = (lastPoint?.y)! + eachPointWidth
        case .RIGHT:
            upPoint.x = (lastPoint?.x)! + eachPointWidth
            upPoint.y = (lastPoint?.y)!
        case .LEFT:
            upPoint.x = (lastPoint?.x)! - eachPointWidth
            upPoint.y = (lastPoint?.y)!
        default:
            break
        }
        breakPointArray.append(upPoint)
        snakeEatFood()
    }
    
    ///开始计时
    private func startTimer() {
        timer.fire()
    }
    ///暂停计时
    private func stopTimer() {
        timer.fireDate = Date.distantFuture
    }
    ///继续计时
    private func continueTimer() {
        timer.fireDate = NSDate.init() as Date
        timer.fireDate = Date.distantPast
    }
    //食物
    lazy var point:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "apple.jpg"))
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return imageView
    }()
    

}

extension SnakeView {
    
    //MARK:绘制网格
    func drawGridding() {
        //网格的单位长宽为eachPointWidth
        let total = Int(self.bounds.size.width/eachPointWidth)
        //竖线
        for i in 0..<total {
            let color = UIColor.green.withAlphaComponent(0)
            color.set()
            let path = UIBezierPath()
            path.lineWidth = 1.0
            path.move(to: CGPoint(x: CGFloat(i) * eachPointWidth, y: 0))
            path.addLine(to: CGPoint(x:CGFloat(i)*eachPointWidth, y: self.bounds.size.height))
            path.stroke()
        }
        //横线
        for i in 0..<total {
            let color = UIColor.green.withAlphaComponent(0)
            color.set()
            let path = UIBezierPath()
            path.lineWidth = 1.0
            path.move(to: CGPoint(x: 0, y: CGFloat(i) * eachPointWidth))
            path.addLine(to: CGPoint(x:self.bounds.size.width, y: CGFloat(i)*eachPointWidth))
            path.stroke()
        }
    }
    
    //MARK:产生随机点
    func createRandomPoint() {
        
        //获取当前的宽和高
        let height = self.bounds.size.height
        let width = self.bounds.size.width
        
        var randomPool_height = [Int]()
        var randomPool_width = [Int]()
        for i in Int(halfEachPointWidth)...Int(height) {
            if (i % Int(halfEachPointWidth) == 0) && (i % 2 != 0) {
                randomPool_height.append(i)
            }
        }
        for i in Int(halfEachPointWidth)...Int(width) {
            if (i % Int(halfEachPointWidth) == 0) && (i % 2 != 0){
                
                randomPool_width.append(i)
            }
        }
        
        let random_x = arc4random() % UInt32(randomPool_width.count-1)
        let random_y = arc4random() % UInt32(randomPool_height.count-1)
        randomPoint.x = CGFloat(randomPool_width[Int(random_x)])
        randomPoint.y = CGFloat(randomPool_height[Int(random_y)])
        point.center = randomPoint
        point.isHidden = false
        
    }
    
    //是否撞到自己
    func containsDuplicate(_ nums:[CGPoint]) -> Bool {
        var newNums = nums
        for i in 0..<nums.count {
            let ele = nums[i]
            newNums.remove(at: i)
            for j in 0..<newNums.count {
                if ele == newNums[j] {
                    return true
                }
            }
            newNums = nums
        }
        return false
    }
}

    


