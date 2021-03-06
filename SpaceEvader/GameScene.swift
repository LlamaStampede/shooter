//
//  GameScene.swift
//  SpaceEvader
//
//  Created by iD Student on 8/2/17.
//  Copyright © 2017 iD Student. All rights reserved.
//

import SpriteKit
import GameplayKit

struct BodyType {
    
    static let None: UInt32 = 0
    static let Meteor: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Hero: UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let hero = SKSpriteNode(imageNamed: "Spaceship")
    
    var heroSpeed : CGFloat = 100
    
    var twoShots = 0
    
    var meteorScore = 0
    var gameOver = false
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    func addMeteor() {
        
        var meteor : Enemy
        
        
        
        meteor = Enemy(imageNamed: "MeteorLeft")
        
        meteor.size.height = 35
        meteor.size.width = 50
        
        let randomY = random() * ((size.height - meteor.size.height/2)-meteor.size.height/2) + meteor.size.height/2
        meteor.position = CGPoint(x: size.width + meteor.size.width/2 , y: randomY)
        
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = BodyType.Meteor
        meteor.physicsBody?.contactTestBitMask = BodyType.Bullet
        meteor.physicsBody?.collisionBitMask = 0
        if gameOver == false
        {addChild(meteor)}
        
        var moveMeteor: SKAction
        if gameOver == false
        {
        moveMeteor = SKAction.move(to: CGPoint(x: -meteor.size.width/2, y: randomY), duration: 5.0)
        
        meteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.lightGray
        
        scoreLabel.fontColor = UIColor.white
        
        scoreLabel.fontSize = 40
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50)
        
        addChild(scoreLabel)
        
        scoreLabel.text = "0"
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 50
        hero.size.width = 50
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.Meteor
        hero.physicsBody?.collisionBitMask = 0
        
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
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor), SKAction.wait(forDuration: 1.0)])))
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        physicsWorld.contactDelegate = self
        
    }
    func swipedUp(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        
        if hero.position.y + heroSpeed >= size.height - hero.size.height/2
        {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: size.height - hero.size.height/2), duration: 0.5)
            print("boundary")
        }
        else
        {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
            print("not boundary")
        }
        hero.run(actionMove)
        print("Up")
    }
    func swipedDown(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        if hero.position.y - heroSpeed <= 0 + hero.size.height/2
        {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.size.height/2), duration: 0.5)
        }
        else
        {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y - heroSpeed), duration: 0.5)
        }
        
        hero.run(actionMove)
        print("Down")
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        if hero.position.x - heroSpeed <= 0 + hero.size.width/2
        {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else
        {

        actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed, y: hero.position.y), duration: 0.5)
        }
        hero.run(actionMove)
        print("Left")
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        var actionMove : SKAction
        if hero.position.x + heroSpeed >= size.width - hero.size.width/2
        {
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else
        {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed, y: hero.position.y), duration: 0.5)
        }
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
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = BodyType.Bullet
        bullet.physicsBody?.contactTestBitMask = BodyType.Meteor
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        if gameOver == false
        {addChild(bullet)}
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let vector = CGVector(dx: -(hero.position.x - touchLocation.x), dy: -(hero.position.y - touchLocation.y))
        if gameOver == false
        {
            let projectileAction = SKAction.sequence([
                SKAction.repeat(
                SKAction.move(by: vector, duration: 0.5), count: 10),
                SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ])
        bullet.run(projectileAction)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let contactA = bodyA.categoryBitMask
        let contactB = bodyB.categoryBitMask
        
        switch contactA {
            
        case BodyType.Meteor:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                break
                
                
                
            case BodyType.Bullet:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    bulletHitMeteor(bullet: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            case BodyType.Hero:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    heroHitMeteor(hero: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Bullet:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    bulletHitMeteor(bullet: bodyANode, meteor: bodyBNode)
                    
                }
                
                
                
            case BodyType.Bullet:
                
                break
                
                
                
            case BodyType.Hero:
                
                break
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Hero:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    heroHitMeteor(hero: bodyANode, meteor: bodyBNode)
                    
                }           
                
                
                
            case BodyType.Bullet:
                
                break     
                
                
                
            case BodyType.Hero:
                
                break       
                
                
                
            default:
                
                break
                
            }
            
            
            
        default:
            
            break
            
        }
    }
    func bulletHitMeteor(bullet : SKSpriteNode, meteor: SKSpriteNode){
        
        if twoShots == 0
        {twoShots = meteorScore}
        if meteorScore >= 10 && twoShots == 0
        {
            twoShots = 2
        }
        if twoShots == 2 || twoShots == 1
        {
            bullet.removeFromParent() //For a stronger bullet change this
            twoShots -= 2
        }
        meteor.removeFromParent()
        
        meteorScore += 1
        
        scoreLabel.text = "\(meteorScore)"
        
        explodeMeteor(meteor: meteor as! Enemy)
    }
    func heroHitMeteor(hero : SKSpriteNode, meteor: SKSpriteNode){
        
        removeAllChildren()
        
        gameOver = true
        
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        
        gameOverLabel.text = "Game Over"
        
        gameOverLabel.fontColor = UIColor.white
        
        gameOverLabel.fontSize = 40
        
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        addChild(gameOverLabel)
        
    }
    
    func explodeMeteor(meteor : Enemy)
    {
        let explosions : [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        for explosion in explosions
        {
            let randomExplosionY = (random() * (1000 + size.width)) - size.width
            let randomExplosionX = (random() * (1000 + size.height)) - size.height
            let moveExplosion : SKAction
            
            moveExplosion = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: 3)
            
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
            explosion.color = UIColor.red
            explosion.size = CGSize(width: 3, height: 3)
            explosion.position = CGPoint(x: meteor.position.x , y: meteor.position.y)
            addChild(explosion)
        }
    }
    
}
