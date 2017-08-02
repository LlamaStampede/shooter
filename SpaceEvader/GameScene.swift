//
//  GameScene.swift
//  SpaceEvader
//
//  Created by iD Student on 8/2/17.
//  Copyright © 2017 iD Student. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let hero = SKSpriteNode(imageNamed: "Spaceship")
    
    var heroSpeed : CGFloat = 100
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.lightGray
        
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 150
        hero.size.width = 150
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        addChild(hero)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
    }
    func swipedUp(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
        hero.run(actionMove)
        print("Up")
    }
    func swipedDown(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y - heroSpeed), duration: 0.5)
        hero.run(actionMove)
        print("Down")
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed, y: hero.position.y), duration: 0.5)
        hero.run(actionMove)
        print("Left")
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed, y: hero.position.y), duration: 0.5)
        hero.run(actionMove)
        print("Right")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var bullet : SKSpriteNode
        
        let randomNum = arc4random_uniform(5)
        //print(randomNum)
        switch randomNum
        {
        case 0:
            //print("Check 1")
            bullet = SKSpriteNode(imageNamed: "bulletRed")
        case 1:
            //print("Check 2")
            bullet = SKSpriteNode(imageNamed: "bulletYellow")
        case 2:
            //print("Check 3")
            bullet = SKSpriteNode(imageNamed: "bulletBlue")
        case 3:
            //print("Check 4")
            bullet = SKSpriteNode(imageNamed: "bulletPink")
        default:
            //print("Check 5")
            bullet = SKSpriteNode(imageNamed: "bullet")
        }
        bullet.size = CGSize(width: 25, height: 42)
        
        bullet.color = UIColor.red
        
        bullet.position = CGPoint(x: hero.position.x, y: hero.position.y)
        
        addChild(bullet)
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let vector = CGVector(dx: -(hero.position.x - touchLocation.x), dy: -(hero.position.y - touchLocation.y))
        
        let projectileAction = SKAction.sequence([
            SKAction.repeat(
                SKAction.move(by: vector, duration: 0.5), count: 10),
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ])
        bullet.run(projectileAction)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
