//
//  ViewController.swift
//  Tap
//
//  Created by AJ Priola on 7/10/15.
//  Copyright © 2015 AJ Priola. All rights reserved.
//

import UIKit
import AudioToolbox

class GameTappyViewController: UIViewController {
    
    var circle:UIView!
    var blue:UIView!
    var thirdCircle:UIView!
    var center:UIView!
    var centerInside:UIView!
    var scoreLabel:UILabel!
    
    var highScoreLabel: UILabel!
    var scoreProgressView: UIProgressView!
    var messageLabel: UILabel!
    @IBOutlet weak var statusLabelLeftConstraint: NSLayoutConstraint!
    var statusLabel: UILabel!
    var centerPoint:CGPoint!
    
    var rotateForward:CABasicAnimation!
    var rotateBackward:CABasicAnimation!
    var messages = ["Good start","Keep it up","You're doing great","Way to go","Keep going!","Epic!","Legendary!","Go play outside.","Put your phone down.","You're too good at this.","You should go pro."]
    var messages2 = ["Nice!","Great!","Awesome!","Super!","Fantastic!"]
    var playing = true
    var score = 0
    var timeMultiple = 1.0
    var blueTime = 4.5
    var redTime = 3.25
    var greenTime = 3.7
    var radius:CGFloat!
    var highscore = 0
    var replacedHighscore = false
    var interactionEnabled = true
    var overlayDisplayed = false
    var overlay:UIView!
    var blueTotalTimeLostResultingFromSpeedChange:Float = 0
    var currentChangeSpeedTime:CFTimeInterval = 0
    var WIDTH_CONSTANT:CGFloat!
    
    var overlayHighscores:[UILabel]!
    var overlayHighscore:UILabel!
    var overlayScore:UILabel!
    var slidelabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-large")!)
        let labe = UILabel(frame: CGRect(x:16,y:30,width:343,height:30))
        labe.textAlignment = .center;
        labe.text = "Tappy"
        view.addSubview(labe)
        
        highScoreLabel = UILabel(frame: CGRect(x:16,y:245,width:343,height:30))
        highScoreLabel.textAlignment = .center
        view.addSubview(highScoreLabel)
        scoreProgressView = UIProgressView(frame: CGRect(x:16,y:235,width:343,height:2))
        view.addSubview(scoreProgressView)
        messageLabel = UILabel(frame: CGRect(x:16,y:187,width:343,height:40))
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        statusLabel = UILabel(frame: CGRect(x:16,y:125,width:343,height:30))
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        
        if let readHighScore = self.getHighScore() {
            self.highscore = readHighScore
            self.highScoreLabel.text = "High Score: \(highscore)"
        }
        
        WIDTH_CONSTANT = self.view.frame.width * 0.17
        
        overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        overlay.frame.origin.x += self.view.frame.width
        makeOverlayLabels()
        view.addSubview(overlay)
        
        centerPoint = CGPoint(x:view.center.x, y:view.center.y * 1.4)
        scoreProgressView.progress = 0
        radius = (self.view.frame.width * 0.6)
        
        center = UIView(frame: CGRect(x:view.center.x, y:view.center.y, width:radius + WIDTH_CONSTANT, height:radius + WIDTH_CONSTANT))
        center.layer.cornerRadius = center.frame.width/2
        center.layer.borderColor = UIColor.black.cgColor
        center.layer.borderWidth = 1
        center.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        center.clipsToBounds = true
        center.center = centerPoint
        view.addSubview(center)
        
        centerInside = UIView(frame: CGRect(x:view.center.x, y:view.center.y, width:radius - WIDTH_CONSTANT, height:radius - WIDTH_CONSTANT))
        centerInside.layer.cornerRadius = centerInside.frame.width/2
        centerInside.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        centerInside.layer.borderWidth = 1
        centerInside.clipsToBounds = true
        centerInside.center = centerPoint
        view.addSubview(centerInside)
        
        circle = UIView(frame: CGRect(x:WIDTH_CONSTANT, y:WIDTH_CONSTANT, width:WIDTH_CONSTANT, height:WIDTH_CONSTANT))
        circle.layer.cornerRadius = WIDTH_CONSTANT/2
        circle.clipsToBounds = true
        circle.backgroundColor = UIColor.white
        circle.center = CGPoint(x:0, y:centerPoint.y + radius)
        
        blue = UIView(frame: CGRect(x:WIDTH_CONSTANT, y:WIDTH_CONSTANT, width:WIDTH_CONSTANT, height:WIDTH_CONSTANT))
        blue.layer.cornerRadius = WIDTH_CONSTANT/2
        blue.clipsToBounds = true
        blue.backgroundColor = UIColor.black
        blue.center = CGPoint(x:centerPoint.x, y:centerPoint.y - radius/2)
        
        thirdCircle = UIView(frame: CGRect(x:WIDTH_CONSTANT, y:WIDTH_CONSTANT, width:WIDTH_CONSTANT, height:WIDTH_CONSTANT))
        thirdCircle.layer.cornerRadius = WIDTH_CONSTANT/2
        thirdCircle.clipsToBounds = true
        thirdCircle.backgroundColor = UIColor.lightGray
        thirdCircle.center = CGPoint(x:centerPoint.x, y:centerPoint.y - radius/2)
        thirdCircle.isHidden = true
        
        scoreLabel = UILabel(frame: CGRect(x:0, y:0, width:30, height:30))
        scoreLabel.text = "\(score)"
        scoreLabel.center = centerPoint
        scoreLabel.textAlignment = .center
        scoreLabel.font = messageLabel.font.withSize(17)
        view.addSubview(scoreLabel)
        self.statusLabel.text = "Tap to begin"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(removeOverlay))
        swipeRight.direction = .down
        overlay.addGestureRecognizer(swipeRight)
        
        blue.layer.speed = 1
        circle.layer.speed = 1
        
        self.view.addSubview(blue)
        self.view.addSubview(circle)
        self.view.addSubview(thirdCircle)
        animateForwards(forwardView: blue, radius: radius, time: blueTime, speed:timeMultiple, key:"blue")
        animateBackwards(forwardView: circle, radius: radius, time: redTime, speed:timeMultiple, key:"red")
        animateForwards(forwardView: thirdCircle, radius: radius, time: greenTime, speed:timeMultiple, key:"green")
        
        //AI fun :)
        //NSTimer.scheduledTimerWithTimeInterval(0.000000001, target: self, selector: "ai", userInfo: nil, repeats: true)
    }
    
    func pauseAnimations() {
        let pausedTimeBlue = blue.layer.convertTime(CACurrentMediaTime(), from: nil)
        blue.layer.speed = 0.0
        blue.layer.timeOffset = pausedTimeBlue
        
        let pausedTimeRed = blue.layer.convertTime(CACurrentMediaTime(), from: nil)
        circle.layer.speed = 0.0
        circle.layer.timeOffset = pausedTimeRed
        
        let pausedTimeGreen = blue.layer.convertTime(CACurrentMediaTime(), from: nil)
        thirdCircle.layer.speed = 0.0
        thirdCircle.layer.timeOffset = pausedTimeGreen
    }
    
    func resumeAnimations() {
        let pausedTimeBlue = blue.layer.timeOffset
        blue.layer.speed = 1
        blue.layer.timeOffset = 0
        blue.layer.beginTime = 0
        let timeSincePauseBlue = blue.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTimeBlue
        blue.layer.beginTime = timeSincePauseBlue
        
        let pausedTimeRed = circle.layer.timeOffset
        circle.layer.speed = 1
        circle.layer.timeOffset = 0
        circle.layer.beginTime = 0
        let timeSincePauseRed = circle.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTimeRed
        circle.layer.beginTime = timeSincePauseRed
        
        let pausedTimeGreen = thirdCircle.layer.timeOffset
        thirdCircle.layer.speed = 1
        thirdCircle.layer.timeOffset = 0
        thirdCircle.layer.beginTime = 0
        let timeSincePauseGreen = blue.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTimeGreen
        thirdCircle.layer.beginTime = timeSincePauseGreen
    }
    
    func makeOverlayLabels() {
        let title = UILabel(frame: CGRect(x:self.view.frame.width,y: self.messageLabel.frame.origin.y, width:self.view.frame.width - 16, height:40))
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.font = self.messageLabel.font.withSize(32)
        title.text = "Game Over"
        overlay.addSubview(title)
        
        let bar = UIView(frame: CGRect(x:self.view.frame.width, y:title.frame.origin.y + 48, width:self.view.frame.width - 16, height:2))
        bar.backgroundColor = UIColor.white
        overlay.addSubview(bar)
        
        let slideview = UIView(frame: CGRect(x:self.view.frame.width, y:title.frame.origin.y - 63, width:self.view.frame.width - 16, height:55))
        
        
        let arrow = UIImageView(image: UIImage(named: "rightwhite"))
        arrow.frame.size = CGSize(width:55, height:55)
        arrow.frame.origin = CGPoint(x:slideview.frame.width - 55, y:0)
        slideview.addSubview(arrow)
        
        let arrow2 = UIImageView(image: UIImage(named: "rightwhite"))
        arrow2.frame.size = CGSize(width:55, height:55)
        arrow2.frame.origin = CGPoint(x:slideview.frame.width - 65, y:0)
        slideview.addSubview(arrow2)
        
        slidelabel = UILabel(frame: CGRect(x:0, y:0, width:slideview.frame.width , height:55))
        slidelabel.font = title.font.withSize(22)
        slidelabel.textColor = UIColor.white
        slidelabel.text = "Slide to play again"
        slidelabel.textAlignment = .center
        slidelabel.sizeToFit()
        slidelabel.frame.size.height = 55
        slidelabel.frame.origin.x = slideview.frame.width - slidelabel.frame.width*2
        
        overlayHighscore = UILabel(frame: CGRect(x:title.frame.origin.x, y:bar.frame.origin.y + 10, width:title.frame.width, height:30))
        overlayHighscore.font = title.font.withSize(26)
        overlayHighscore.textAlignment = .center
        overlayHighscore.textColor = UIColor.white
        overlayHighscore.text = "High Score: \(highscore)"
        overlay.addSubview(overlayHighscore)
        
        overlayScore = UILabel(frame: CGRect(x:overlayHighscore.frame.origin.x, y:overlayHighscore.frame.origin.y + 48, width:title.frame.width, height:30))
        overlayScore.font = title.font.withSize(26)
        overlayScore.textAlignment = .center
        overlayScore.textColor = UIColor.white
        overlayScore.text = "You scored: \(score)"
        overlay.addSubview(overlayScore)
        
        slideview.addSubview(slidelabel)
        overlay.addSubview(slideview)
    }
    
    func flashSlide() {
        UILabel.animate(withDuration: 1.5) { () -> Void in
            self.slidelabel.alpha = 0
        }
        self.slidelabel.alpha = 1
    }
    
    func changeBackgroundGradient(bottom:UIColor, top:UIColor) {
        let vista : UIView = UIView(frame: self.view.frame)
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = vista.bounds
        let arrayColors = [top, bottom]
        
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func ai() {
        if (blue.layer.presentation()?.frame)!.intersects((circle.layer.presentation()?.frame)!) {
            tapped()
        }
    }
    
    func saveHighScore(score:Int) {
        /*
        var higher = false
        for n in getTopFive() {
            if score > n {
                higher = true
                break
            }
        }
        
        if higher {
            saveTopFive(score)
        }
        */
        UserDefaults.standard.set(score, forKey: "highscore")
    }
    
    func getHighScore() -> Int? {
        return UserDefaults.standard.integer(forKey: "highscore")
    }
    
    func getTopFive() -> [Int] {
        return UserDefaults.standard.object(forKey: "highscores") as! [Int]
    }
    
    func saveTopFive(score:Int) {
        let s:[Int] = getTopFive()
        var sorted:[Int] = s.sorted()
        sorted.remove(at: 0)
        sorted.append(score)
        UserDefaults.standard.set(sorted.sort(), forKey: "highscores")
    }
    
    func animateForwards(forwardView:UIView, radius:CGFloat, time:Double, speed:Double, key:String) {
        let rotationPoint = centerPoint
        
        //let anchorPoint = CGPointMake((rotationPoint.x + radius/2)/(radius), (rotationPoint.y + radius/2)/(radius))
        //find center of blue
        
        let distanceUnit = radius/blue.frame.width
        //print(distanceUnit)
        let centerBlue = CGPoint(x:distanceUnit * 0.494, y:distanceUnit * 0.494)
        //blue.layer.position = centerBlue
        //let anchorPoint = CGPointMake(0.5, 0.5)
        forwardView.layer.anchorPoint = centerBlue
        forwardView.layer.position = rotationPoint!
        
        rotateForward = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateForward.toValue = (M_PI) * 2
        rotateForward.duration = time
        rotateForward.repeatCount = Float.infinity
        forwardView.layer.add(rotateForward, forKey: key)
        //print("r:\(rotationPoint)")
        //print("a:\(anchorPoint)")
    }
    
    func updateAnimation(view:UIView, animation:CABasicAnimation, speed:Double, key:String) {
        let layerFrame = view.layer.presentation()?.frame
        blue.frame.origin = (layerFrame?.origin)!
        view.layer.removeAllAnimations()
        animateForwards(forwardView: blue, radius: radius, time: blueTime, speed: timeMultiple, key: "blue")
        
    }
    
    func animateBackwards(forwardView:UIView, radius:CGFloat, time:Double, speed:Double, key:String) {
        /*
        let rotationPoint = centerPoint
        
        let anchorPoint = CGPointMake((rotationPoint.x + radius/2)/(radius), (rotationPoint.y + radius/2)/(radius))
        forwardView.layer.anchorPoint = anchorPoint
        forwardView.layer.position = rotationPoint*/
        
        let rotationPoint = centerPoint
        
        //let anchorPoint = CGPointMake((rotationPoint.x + radius/2)/(radius), (rotationPoint.y + radius/2)/(radius))
        //find center of blue
        
        let distanceUnit = radius/blue.frame.width
        //print(distanceUnit)
        let centerBlue = CGPoint(x:distanceUnit * 0.494, y:distanceUnit * 0.494)
        //blue.layer.position = centerBlue
        //let anchorPoint = CGPointMake(0.5, 0.5)
        forwardView.layer.anchorPoint = centerBlue
        forwardView.layer.position = rotationPoint ?? CGPoint(x:0,y:0)
        
        rotateBackward = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateBackward.toValue = (-M_PI) * 2
        rotateBackward.duration = time
        rotateBackward.repeatCount = Float.infinity
        forwardView.layer.add(rotateBackward, forKey: key)
    }
    
    func calculateSpeed() {
        var divisor = 250
        switch score {
        case 0...10:
            divisor = 200
        case 11...20:
            divisor = 450
        case 21...30:
            divisor = 690
        case 31...40:
            divisor = 900
        default:
            divisor = 1100
        }
        self.timeMultiple = (Double(score) / Double(divisor))
        
        self.blueTime += blueTime * timeMultiple
        self.redTime += redTime * timeMultiple
        
        let blueVal = blue.layer.convertTime(CACurrentMediaTime(), from: blue.layer) - currentChangeSpeedTime
        let blueCurrentTimeLostResultingFromSpeedChange = Float(blueVal) - (Float(blueVal) * blue.layer.speed)
        blueTotalTimeLostResultingFromSpeedChange += blueCurrentTimeLostResultingFromSpeedChange
        
        currentChangeSpeedTime = blue.layer.convertTime(CACurrentMediaTime(), from: blue.layer)
        blue.layer.timeOffset = CFTimeInterval(Float(currentChangeSpeedTime) - blueTotalTimeLostResultingFromSpeedChange)
        blue.layer.beginTime = CACurrentMediaTime()
        blue.layer.speed += Float(timeMultiple)
        
        circle.layer.timeOffset = CFTimeInterval(Float(currentChangeSpeedTime) - blueTotalTimeLostResultingFromSpeedChange)
        circle.layer.beginTime = CACurrentMediaTime()
        circle.layer.speed += Float(timeMultiple)
    }
    
    func flashScreen() {
        if let wnd = self.view{
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = UIColor.white
            v.alpha = 0.9
            wnd.addSubview(v)
            UIView.animate(withDuration: 0.5, animations: {
                v.alpha = 0.0
                }, completion: {(finished:Bool) in
                    v.removeFromSuperview()
            })
        }
    }
    
    func startGame() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-large")!)
        centerInside.backgroundColor = UIColor.clear
        scoreLabel.textColor = UIColor.black
        self.blue.isHidden = false
        self.circle.isHidden = false
        replacedHighscore = false
        playing = true
        timeMultiple = 1
        self.scoreLabel.text = "0"
        blue.layer.speed = 1
        circle.layer.speed = 1
        animateTextChange(label: statusLabel, text: "Tap when the circles overlap")
        calculateSpeed()
    }
    
    @objc func tapped() {
        if overlayDisplayed { return }
        
        guard playing && interactionEnabled else {
            if !playing { startGame() }
            return
        }
        
        let blueFrame = self.blue.layer.presentation()?.frame
        let redFrame = self.circle.layer.presentation()?.frame
        let greenFrame = self.thirdCircle.layer.presentation()?.frame
        if self.thirdCircle.isHidden {
            if blueFrame!.intersects(redFrame!) {
                score += 1
                flashScreen()
                UILabel.animate(withDuration: 5, animations: { () -> Void in
                    self.messageLabel.text = ""
                })
            } else {
                gameOver()
                return
            }
        } else {
            
            if blueFrame!.intersects(redFrame!) && greenFrame!.intersects(redFrame!) && blueFrame!.intersects(greenFrame!) {
                score += 6
                self.thirdCircle.isHidden = true
                flashScreen()
                animateTextChange(label: messageLabel, text: "Triple!")
            } else if greenFrame!.intersects(redFrame!) || blueFrame!.intersects(greenFrame!) {
                score += 3
                self.thirdCircle.isHidden = true
                flashScreen()
                let i = Int(arc4random_uniform(UInt32(2)))
                animateTextChange(label: messageLabel, text: messages2[i])
            } else if redFrame!.intersects(blueFrame!) {
                score += 1
                flashScreen()
            } else {
                gameOver()
                return
            }
        }
        animateTextChange(label: scoreLabel, text: "\(score)")
        
        if arc4random() % 3 == 0 {
            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.thirdCircle.isHidden = false
            })
            
        }
        var index = score/10
        if index > messages.count - 1 { index = messages.count - 1 }
        if (score % 10 == 0 && score > 9) || (score == 1) {
            animateTextChange(label: statusLabel, text: messages[index])
        }
        if score <= 10 {
            let progress = Double(score)/10
            scoreProgressView.setProgress(Float(progress), animated: true)
            //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            let progress = (Int(score) % 10) / 10
            scoreProgressView.setProgress(Float(progress), animated: true)
            //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if score > highscore {
            highscore = score
            self.highScoreLabel.text = "High Score: \(highscore)"
            if !replacedHighscore {
                replaceHighscore()
            }
        }
        
        if score >= 30 {
            scoreLabel.textColor = UIColor.red
        }
        
        if score >= 45 {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-orange")!)
        }
        
        if score >= 85 {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-red")!)
        }
        saveHighScore(score: score)
        calculateSpeed()
    }
    
    func displayOverlay() {
        messageLabel.isHidden = true
        statusLabel.isHidden = true
        highScoreLabel.isHidden = true
        scoreLabel.isHidden = true
        interactionEnabled = false
        UIView.animate(withDuration: 1) { () -> Void in
            self.overlay.frame.origin.x = 0
        }
        overlayDisplayed = true
        for (index,element) in overlay.subviews.enumerated() {
            UIView.animate(withDuration: 0.6, delay:Double(index) * 0.6, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                element.frame.origin.x = 8
            }, completion: nil)
            
            
//            UIView.animateWithDuration(0.6, delay: Double(overlay.subviews.indexOf(element)!) * 0.6, options: UIView.AnimationOptions.CurveEaseOut, animations: { () -> Void in
//                element.frame.origin.x = 8
//                }, completion: nil)
        }
    }
    
    @objc func removeOverlay() {
        messageLabel.isHidden = false
        statusLabel.isHidden = false
        highScoreLabel.isHidden = false
        scoreLabel.isHidden = false
        interactionEnabled = true
        UIView.animate(withDuration: 0.8) { () -> Void in
            self.overlay.frame.origin.x = self.view.frame.width
            for element in self.overlay.subviews {
                element.frame.origin.x = self.view.frame.width + 8
            }
        }
        
        overlayDisplayed = false
        startGame()
    }
    
    func replaceHighscore() {
        let new = UILabel(frame: self.highScoreLabel.frame)
        new.frame.origin.x += self.view.frame.width + 8
        new.font = highScoreLabel.font
        new.text = "High Score: \(score)"
        UILabel.animate(withDuration: 0.5) { () -> Void in
            new.frame.origin.x = self.highScoreLabel.frame.origin.x
        }
        UILabel.animate(withDuration: 0.5) { () -> Void in
            self.highScoreLabel.frame.origin.x -= (self.view.frame.width + 8)
        }
        replacedHighscore = true
    }
    
    func gameOver() {
        self.blue.isHidden = true
        self.circle.isHidden = true
        self.thirdCircle.isHidden = true
        score = 0
        playing = false
        animateTextChange(label: statusLabel, text: "Tap to begin")
        messageLabel.text = ""
        scoreProgressView.setProgress(0, animated: true)
        saveHighScore(score: highscore)
        displayOverlay()
    }
    
    func animateTextChange(label:UILabel, text:String) {
        label.alpha = 0.0
        label.text = text
        UILabel.animate(withDuration: 1) { () -> Void in
            label.alpha = 1.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

