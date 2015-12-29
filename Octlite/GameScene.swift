//
//  GameScene.swift
//  Octlite
//
//  Created by Pop Pro on 11/26/15.
//  Copyright (c) 2015 Poppro. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var level = 1
    var times:Int = 0;
    var count = 0
    let data = NSUserDefaults.standardUserDefaults()
    var timer:NSTimer? = nil;
    var achieved = 0
    var col = [Int]()
    var dir = [Int]() //0 = LR 1 = UD
    var hold = 0
    var started = 0
    var pos = 0
    var failed = false
    var ballTime = 1.75
    var fio = 0

    
    override func didMoveToView(view: SKView) {
        //setup persistance
        if data.integerForKey("level") != 0 {
        level = data.integerForKey("level")
        }
        
        //setup right swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view!.addGestureRecognizer(swipeRight)
        //setup left swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        //phyics
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        for var i = 500; i < 504; i++ {
            let bL = self.childNodeWithName("\(i)")
            bL?.physicsBody = SKPhysicsBody(rectangleOfSize: (bL?.frame.size)!);
            bL?.physicsBody?.friction = 20
            bL?.physicsBody?.usesPreciseCollisionDetection = true
            bL?.physicsBody?.collisionBitMask = 1
        }
        //handle misc nodes
        if let indicator = self.childNodeWithName("Level") as? SKLabelNode {
            indicator.text = level.description
        }

        //handle timers
        startTime()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05,
            target: self,
            selector: "check",
            userInfo: nil,
            repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
        let location = touch.locationInNode(self)
        let button = self.childNodeWithName("fButton")
            if button != nil {
            if button!.containsPoint(location) {
                let fL = self.childNodeWithName("fLab")
                fL?.removeFromParent()
                button?.removeFromParent()
                times = 0
                fio = 0
                startTime()
            }
            }
        }
    }

    func startTime() {
        timer = NSTimer.scheduledTimerWithTimeInterval(ballTime,
            target: self,
            selector: "ballSpawner:",
            userInfo: nil,
            repeats: false)
    }
    
    func ballSpawner(timer:NSTimer) {
        times++
        started = 1
        if fio == 1 {
            self.timer?.invalidate()
        }
        if times < level {
            self.startTime()
        }
            var x = 0
            var y = 0
            let randomNumber = Int(arc4random_uniform(UInt32(4)))
            let randomCol = Int(arc4random_uniform(UInt32(4)))
            if randomNumber == 0 {
                x = Int(arc4random_uniform(UInt32(30))) + 15
                dir.append(0)
             }
            if randomNumber == 1 {
                x = -Int(arc4random_uniform(UInt32(30))) - 15
                dir.append(0)
            }
            if randomNumber == 2 {
                y = Int(arc4random_uniform(UInt32(30))) + 15
                dir.append(1)
            }
            if randomNumber == 3 {
                y = -Int(arc4random_uniform(UInt32(50))) - 15
                dir.append(1)
            }
            let Circle = SKShapeNode(circleOfRadius: 10 ) // Size of Circle
            Circle.position = CGPointMake(self.frame.midX + 13, self.frame.midY + 27)  //Middle of Screen
            //color selector
            if randomCol == 0 { //green
                Circle.fillColor = SKColor.greenColor()
                col.append(0)
            }
            if randomCol == 1 { //purple
                Circle.fillColor = SKColor.purpleColor()
                col.append(1)
            }
            if randomCol == 2 { //cyan
                Circle.fillColor = SKColor.cyanColor()
                col.append(2)
            }
            if randomCol == 3 { //red
                Circle.fillColor = SKColor.redColor()
                col.append(3)
            }
            Circle.antialiased = true
            Circle.strokeColor = SKColor.clearColor()
            Circle.physicsBody = SKPhysicsBody(rectangleOfSize: Circle.frame.size)
            Circle.physicsBody?.velocity = CGVector(dx: x , dy: y)
            Circle.physicsBody?.linearDamping = 0
            Circle.physicsBody?.collisionBitMask = 0
            count++
            Circle.name = count.description
            self.addChild(Circle)
    }
    
    //handle swipe gestures
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let oct = self.childNodeWithName("Octagon")
        let animR = SKAction.rotateByAngle(0.785398, duration: 0.15)
        let animL = SKAction.rotateByAngle(-0.785398, duration: 0.15)
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                    pos--
                    oct?.runAction(animR)
            case UISwipeGestureRecognizerDirection.Left:
                pos++
                oct?.runAction(animL)
            default:
                break
            }
        }
    }
    
    
    func check() {
        for var i = 0; i < count; i++ {
            let circ = self.childNodeWithName("\(i + 1)")
            if (circ?.position.y != nil) {
                if (circ?.position.y)! - self.frame.midY + 27 < -95 {
                    if pos == 0 && col[i] == 0 {
                        hold++
                        achieved++
                    } else if (pos == 1 || pos == 3) && col[i] == 3 {
                        hold++
                        achieved++
                    } else if (pos == 2 || pos == -2) && col[i] == 1 {
                        hold++
                        achieved++
                    } else if (pos == 3 || pos == -1) && col[i] == 2 {
                        hold++
                        achieved++
                    } else {
                        failed = true
                    }
                    circ?.removeFromParent()
                }
                if (circ?.position.y)! - self.frame.midY > 179 {
                    if pos == 0 && col[i] == 0 {
                        hold++
                        achieved++
                    } else if (pos == 1 || pos == -3) && col[i] == 3 {
                        hold++
                        achieved++
                    } else if (pos == 2 || pos == -2) && col[i] == 1 {
                        hold++
                        achieved++
                    } else if (pos == 3 || pos == -1) && col[i] == 2 {
                        hold++
                        achieved++
                    } else {
                        failed = true
                    }
                    circ?.removeFromParent()
                }
                if (circ?.position.x)! - self.frame.midX + 13 > 175{
                    if pos == 0 && col[i] == 1 {
                        hold++
                        achieved++
                    } else if (pos == 3 || pos == -1) && col[i] == 3 {
                        hold++
                        achieved++
                    } else if (pos == 2 || pos == -2) && col[i] == 0 {
                        hold++
                        achieved++
                    } else if (pos == 1 || pos == -3) && col[i] == 2 {
                        hold++
                        achieved++
                    } else {
                        failed = true
                    }
                    circ?.removeFromParent()
                }
                if (circ?.position.x)! - self.frame.midX + 13 < -125 {
                    if pos == 0 && col[i] == 1 {
                        hold++
                        achieved++
                    } else if (pos == 3 || pos == -1) && col[i] == 3 {
                        hold++
                        achieved++
                    } else if (pos == 2 || pos == -2) && col[i] == 0 {
                        hold++
                        achieved++
                    } else if (pos == 1 || pos == -3) && col[i] == 2 {
                        hold++
                        achieved++
                    } else {
                        failed = true
                    }
                    circ?.removeFromParent()
                }
            }
        }
        if level == achieved {
            achieved = 0
            times = 0
            level += 1
            data.setInteger(level, forKey: "level")
            data.synchronize()
            if let indicator = self.childNodeWithName("Level") as? SKLabelNode {
                indicator.text = level.description
            }
            startTime()
        }
    }
    
    func failure() {
        if fio != 1 {
        let fLabel = SKLabelNode(fontNamed: "Arial")
        fLabel.text = "You failed at level: \(level)"
        fLabel.fontSize = 40
        fLabel.fontColor = SKColor.blackColor()
        fLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        fLabel.zPosition = 5
        fLabel.name = "fLab"
        self.addChild(fLabel)
        let fButton = SKLabelNode(fontNamed: "Arial")
        fButton.text = "Retry"
        fButton.fontSize = 30
        fButton.fontColor = SKColor.blackColor()
        fButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-50)
        fButton.name="fButton"
        fButton.zPosition = 5
        self.addChild(fButton)
        for var i = 0; i < count; i++ {
            let circ = self.childNodeWithName("\(i + 1)")
            circ?.removeFromParent()
        }
        times = level
        failed = false
        achieved = 0
        fio = 1
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if pos == -4 || pos == 4 {
            pos = 0
        }
        if failed == true {
            failure()
        }
    }
}
