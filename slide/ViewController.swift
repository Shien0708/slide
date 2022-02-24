//
//  ViewController.swift
//  slide
//
//  Created by 方仕賢 on 2022/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundStepper: UIStepper!
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var roundWordLabel: UILabel!
    @IBOutlet weak var changeColorButton: UIButton!
    
    var animator = UIViewPropertyAnimator()
    let baseWidth = 380
    var translateX = 0
    var translateY = 100
    var ballOriginX = 370
    var ballOriginY = 70
    var time = 0
    var ballViews = [UIView]()
    var pusherViews = [UIView]()
    var roundTime: Float = 0
    var round = 0
    var leftColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
    var rightColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        for y in stride(from: 0, to: 5, by: 2){
            
            rightTriangle(height: 100, originY: y*100+100, color: rightColor)
            oppRightTriangle(height: 100, originY: y*100+200, color: rightColor)
            leftTriangle(height: 100, originY: y*100+200, color: leftColor)
            oppLeftTriangle(height: 100, originY: y*100+300, color: leftColor)
        }
        base()
        pusher(y: 700)
        view.bringSubviewToFront(rollButton)
        view.bringSubviewToFront(roundStepper)
        view.bringSubviewToFront(roundLabel)
        view.bringSubviewToFront(roundWordLabel)
        
    }
    func roll(rounds: Int){
        roundTime = 0
        
        for i in 0...rounds-1 {
            roundTime = 8.2 * Float(i)
            _ = Timer.scheduledTimer(withTimeInterval:TimeInterval(roundTime), repeats: false, block: { _ in
                self.oneRound()
                self.round -= 1
                self.roundLabel.text = "\(self.round)"
                self.roundStepper.value = Double(self.round)
                if self.round > 1 {
                    self.roundWordLabel.text = "Rounds"
                } else {
                    self.roundWordLabel.text = "Round"
                }
                
            })
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: Double(rounds)*8.2, repeats: false, block: { _ in
            if self.round == 0 {
                self.rollButton.isHidden = false
                self.roundStepper.isHidden = false
                self.view.bringSubviewToFront(self.rollButton)
                self.view.bringSubviewToFront(self.roundStepper)
                self.rollButton.isEnabled = false
                self.changeColorButton.isHidden = false
            }
        })
        
    }
    
    func oneRound(){
        translateX = 0
        translateY = 100
        ballOriginX = 370
        ballOriginY = 70
        time = 0
        if ballViews.count >= 1 {
            ballViews[0].removeFromSuperview()
            ballViews.removeFirst()
            pusherViews[1].removeFromSuperview()
            pusherViews.removeLast()
        }
        
        for layer in 1...6{
            moveTheBall(layer: layer)
        }
        push()
    }
    
    func pusher(y: Int) -> UIView{
        let pusherView = UIView(frame: CGRect(x: baseWidth, y: y, width: 50, height: 1300))
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y:0 ))
        path.addLine(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 1300))
        path.addLine(to: CGPoint(x: 0, y: 1300))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.brown.cgColor
        pusherView.layer.addSublayer(layer)
        pusherViews.append(pusherView)
        view.addSubview(pusherView)
        return pusherView
    }
    
    func push(){
        _ = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: { _ in
            self.animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear, animations: {
                self.ballViews[0].removeFromSuperview()
                self.ballViews.removeFirst()
                self.ballOriginY = 680
                self.ballOriginX = 360
                self.ball(x: self.ballOriginX, y: self.ballOriginY).transform = CGAffineTransform(translationX: 50, y: 0)
                self.ballOriginX = 410
            })
            self.animator.startAnimation()
        })
        
        _ = Timer.scheduledTimer(withTimeInterval: 6.1, repeats: false, block: { _ in
            self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.ballViews[0].removeFromSuperview()
                self.ballViews.removeFirst()
                self.pusher(y:700).transform = CGAffineTransform(translationX: 0, y: -600)
                self.ball(x: self.ballOriginX, y: self.ballOriginY).transform = CGAffineTransform(translationX: 0, y: -600)
                self.ballOriginY -= 600
            })
            self.animator.startAnimation()
        })
        
        _ = Timer.scheduledTimer(withTimeInterval: 7.1, repeats: false, block: { _ in
            self.animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear, animations: {
                self.ballViews[0].removeFromSuperview()
                self.ballViews.removeFirst()
                self.ballOriginY = 85
                self.ball(x: self.ballOriginX, y: self.ballOriginY).transform = CGAffineTransform(translationX: -50, y: 0)
                self.ballOriginX = 360
            })
            self.animator.startAnimation()
        })
        
        _ = Timer.scheduledTimer(withTimeInterval: 7.2, repeats: false, block: { _ in
            self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.pusherViews[1].removeFromSuperview()
                self.pusherViews.removeLast()
                self.pusher(y:100).transform = CGAffineTransform(translationX: 0, y: 600)
               
            })
            self.animator.startAnimation()
        })
        
       
    }
    
    
    func base() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 700))
        path.addLine(to: CGPoint(x: 0, y: 1000))
        path.addLine(to: CGPoint(x: baseWidth, y: 1000))
        path.addLine(to: CGPoint(x: baseWidth, y: 700))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.brown.cgColor
        view.layer.addSublayer(layer)
    }
    
    func leftTriangle(height: Int, originY: Int, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: originY))
        path.addLine(to: CGPoint(x:0 , y: originY+height))
        path.addLine(to: CGPoint(x: baseWidth, y: originY+height))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = color
        view.layer.addSublayer(layer)
        
    }
    
    func oppLeftTriangle(height: Int, originY: Int, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: originY))
        path.addLine(to: CGPoint(x:0 , y: originY+height))
        path.addLine(to: CGPoint(x: baseWidth, y: originY))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = color
        view.layer.addSublayer(layer)
        
    }
    
    func rightTriangle(height: Int, originY: Int, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: originY+height))
        path.addLine(to: CGPoint(x:baseWidth , y: originY+height))
        path.addLine(to: CGPoint(x: baseWidth, y: originY))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = color
        view.layer.addSublayer(layer)
        
    }
    
    func oppRightTriangle(height: Int, originY: Int, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: originY))
        path.addLine(to: CGPoint(x:baseWidth , y: originY))
        path.addLine(to: CGPoint(x: baseWidth, y: originY+height))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = color
        view.layer.addSublayer(layer)
    }
    
    func ball(x: Int, y: Int) -> UIView{
        let ballView = UIView(frame: CGRect(x: x, y: y, width: 40, height: 40))
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 20, startAngle: 0, endAngle: 360, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.black.cgColor
        ballView.layer.addSublayer(layer)
        view.addSubview(ballView)
        ballViews.append(ballView)
        return ballView
    }
    
    func moveTheBall(layer: Int){
        
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { _ in
            
            if layer % 2 == 1 {
                self.translateX = -350
                self.ballOriginX = 370
                print("yes")
            } else {
                self.translateX = 350
                self.ballOriginX = 0
                print("no")
            }
            self.ballOriginY = -20
            self.ballOriginY += layer*100
            
            self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.ball(x: self.ballOriginX, y: self.ballOriginY).transform = CGAffineTransform(translationX: CGFloat(self.translateX), y: CGFloat(self.translateY))
            })
            self.animator.startAnimation()
            
        })
        
        if time >= 1 {
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { _ in
                self.ballViews[0].removeFromSuperview()
                self.ballViews.removeFirst()
            })
        }
        
        time += 1
    }

    
    @IBAction func setRounds(_ sender: UIStepper) {
        roundLabel.text = "\(Int(sender.value))"
        round = Int(sender.value)
        if round > 1 {
            roundWordLabel.text = "Rounds"
        } else {
            roundWordLabel.text = "Round"
        }
        if round == 0 {
            rollButton.isEnabled = false
        } else {
            rollButton.isEnabled = true
        }
    }
    
    @IBAction func rollTheBall(_ sender: Any) {
        roll(rounds: round)
        rollButton.isHidden = true
        roundStepper.isHidden = true
        changeColorButton.isHidden = true
    }
    
    
    @IBAction func changeColor(_ sender: Any) {
        leftColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
        rightColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
        for y in stride(from: 0, to: 5, by: 2){
            
            rightTriangle(height: 100, originY: y*100+100, color: rightColor)
            oppRightTriangle(height: 100, originY: y*100+200, color: rightColor)
            leftTriangle(height: 100, originY: y*100+200, color: leftColor)
            oppLeftTriangle(height: 100, originY: y*100+300, color: leftColor)
        }
        base()
        view.bringSubviewToFront(rollButton)
        view.bringSubviewToFront(roundStepper)
        view.bringSubviewToFront(roundLabel)
        view.bringSubviewToFront(roundWordLabel)
    }
    
}

