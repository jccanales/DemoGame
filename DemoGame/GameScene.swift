//
//  GameScene.swift
//  DemoGame
//
//  Created by Jean Carlo Canales Martinez on 1/29/16.
//  Copyright (c) 2016 Jean Carlo Canales Martinez. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate{
    func changeDevice(data: NSData)
}

class GameScene: SKScene {
    
    var isFingerOnSpaceship = false
    var timesTouched = 0
    var sprite = SKSpriteNode(imageNamed:"Spaceship")
    var shouldSendShip = false
    var playerNumber = 0
    
    let spaceshipManager = SpaceshipServiceManager()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let screenSize = CGRectMake(0, 0, self.frame.width, self.frame.height + 200)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: screenSize)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        self.spaceshipManager.delegate = self
        
        /* Setup your scene here */
        
        //let vector = CGVector(dx: 100, dy: 100)
        //sprite.physicsBody?.applyImpulse(vector)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch = touches.first
        
        let location = touch!.locationInNode(self)
            
        let body = self.physicsWorld.bodyAtPoint(location)
            
        if( body?.node?.name == "spaceship" ){
            self.isFingerOnSpaceship = true
            self.timesTouched++
            if(self.timesTouched > 1){
                let spaceShip = self.childNodeWithName("spaceship")
                
                spaceShip?.physicsBody?.velocity = CGVectorMake(0, 0)
                self.timesTouched = 0
            }
        }else{
            self.timesTouched = 0
        }
        
        if(playerNumber == 0){
            
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(self.isFingerOnSpaceship){
            
            let touch = touches.first
            let location = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            let spaceShip = self.childNodeWithName("spaceship")
            
            let vector = CGVectorMake((location.x - previousLocation.x) * 10, (location.y - previousLocation.y) * 10)
            spaceShip?.physicsBody!.applyImpulse(vector)
            
            /*
            var spaceShipX = (spaceShip?.position.x)! + (location.x - previousLocation.x)
            var spaceShipY = (spaceShip?.position.y)! + (location.y - previousLocation.y)
            
            spaceShipX = max(spaceShipX, (spaceShip?.frame.size.width)!/2)
            spaceShipX = min(spaceShipX, self.frame.size.width - (spaceShip?.frame.size.width)! / 2)
            
            spaceShipY = max(spaceShipY, (spaceShip?.frame.size.width)!/2)
            spaceShipY = min(spaceShipY, self.frame.size.width - (spaceShip?.frame.size.width)! / 2)
            
            spaceShip?.position = CGPoint(x: spaceShipX, y: spaceShipY)
            */
            
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.isFingerOnSpaceship = false
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //NSLog("\(sprite.position.y)")
        
        if(sprite.position.y > self.frame.size.height && self.shouldSendShip){
            let data = NSKeyedArchiver.archivedDataWithRootObject(sprite)
            self.spaceshipManager.sendShipData(data)
            sprite.removeFromParent()
            self.shouldSendShip = false
        }
        
        if(sprite.position.y < 150 && sprite.position.y > 0){
            self.shouldSendShip = true
        }
    }
    
}

extension GameScene: SpaceshipServiceManagerDelegate{
    
    func addFirstShip() {
        
        sprite.name = "spaceship"
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.frame.size)
        sprite.physicsBody?.dynamic = true
        sprite.physicsBody?.restitution = 1.0
        sprite.physicsBody?.friction = 0.0
        sprite.physicsBody?.linearDamping = 0.0
        sprite.physicsBody?.allowsRotation = false
        
        //self.shouldSendShip = true

    }
    
    
    func addSpaceshipToScene(sprite: SKSpriteNode) {
        
        self.sprite.removeFromParent()
        self.sprite = sprite
        
        sprite.physicsBody?.velocity = CGVectorMake(-(sprite.physicsBody?.velocity.dx)!, -(sprite.physicsBody?.velocity.dy)!)
        
        sprite.zRotation = CGFloat(M_PI)
        
        self.sprite.position.x = self.frame.width - sprite.position.x
        
        self.addChild(self.sprite)
        
    }
    
}

