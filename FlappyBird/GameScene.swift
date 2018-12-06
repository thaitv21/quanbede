//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var dieBlock: ((_ score: Int) -> ())?
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var landTexture:SKTexture!
    var mushroom1Texture: SKTexture!
    var mushroom2Texture: SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var vitalyLabelNode:SKLabelNode!
    var score = NSInteger()
    var isDead = false
    var jumpCount = 15 {
        didSet {
            vitalyLabelNode.text = "Jump Count: \(jumpCount)"
        }
    }
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let vitalyCategory: UInt32 = 1 << 4
    
    override func didMove(to view: SKView) {
        
        canRestart = true
        
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 221.0/255.0, green: 248.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for i in 0 ..< 2 + Int(self.frame.size.width / ( groundTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest
        
        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for i in 0 ..< 2 + Int(self.frame.size.width / ( skyTexture.size().width * 2 )) {
            let i = CGFloat(i)
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }
        
        // create the pipes textures
//        pipeTextureUp = SKTexture(imageNamed: "land1")
//        pipeTextureUp.filteringMode = .nearest
        landTexture = SKTexture(imageNamed: "land1")
        landTexture.filteringMode = .nearest
        
        mushroom1Texture = SKTexture(imageNamed: "mushroom_1")
        mushroom2Texture = SKTexture(imageNamed: "mushroom_2")
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * landTexture.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.005 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: TimeInterval(1.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever)
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "Run_000")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "Run_001")
        birdTexture2.filteringMode = .nearest
        let birdTexture3 = SKTexture(imageNamed: "Run_003")
        birdTexture3.filteringMode = .nearest
        let birdTexture4 = SKTexture(imageNamed: "Run_004")
        birdTexture4.filteringMode = .nearest
        let birdTexture5 = SKTexture(imageNamed: "Run_005")
        birdTexture5.filteringMode = .nearest
        let birdTexture6 = SKTexture(imageNamed: "Run_006")
        birdTexture6.filteringMode = .nearest
        let birdTexture7 = SKTexture(imageNamed: "Run_007")
        birdTexture7.filteringMode = .nearest
        let birdTexture8 = SKTexture(imageNamed: "Run_008")
        birdTexture8.filteringMode = .nearest
        let birdTexture9 = SKTexture(imageNamed: "Run_009")
        birdTexture9.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [birdTexture1, birdTexture2, birdTexture3, birdTexture4, birdTexture5, birdTexture6, birdTexture7, birdTexture8, birdTexture9], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(0.22)
        bird.position = CGPoint(x: self.frame.size.width * 0.45, y:self.frame.size.height * 0.6)
        bird.run(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = pipeCategory | vitalyCategory
        
        self.addChild(bird)
        
        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = pipeCategory
        self.addChild(ground)
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.fontSize = 20
        scoreLabelNode.position = CGPoint( x: self.frame.midX - 150, y: self.frame.minY + 70 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = "Score: \(score)"
        self.addChild(scoreLabelNode)
        
        vitalyLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        vitalyLabelNode.fontSize = 20
        vitalyLabelNode.position = CGPoint( x: self.frame.midX + 100, y: self.frame.minY + 70)
        vitalyLabelNode.zPosition = 100
        jumpCount = 15
        self.addChild(vitalyLabelNode)
        
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + landTexture.size().width * 2, y: 0 )
        pipePair.zPosition = 10
        
        let height = UInt32( self.frame.size.height / 3)
        let y = Double(arc4random_uniform(height) + height)
        
        let landFly = SKSpriteNode(texture: landTexture)
        landFly.setScale(1)
        landFly.position = CGPoint(x: 0.0, y: y)
        
        
        
        
        landFly.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: landFly.size.width, height: landFly.size.height * 0.9))
        
        landFly.physicsBody?.isDynamic = false
        landFly.physicsBody?.categoryBitMask = worldCategory
        landFly.physicsBody?.node?.name = "wold"
        
        pipePair.addChild(landFly)
        if Int.random(in: 0 ... 6) < 2 {
            let mushroom2 = SKSpriteNode(texture: mushroom2Texture)
            mushroom2.setScale(1)
            mushroom2.position = CGPoint(x: 0.0, y: y + Double(mushroom2.size.height) - 40 )
            mushroom2.physicsBody = SKPhysicsBody(circleOfRadius: mushroom2.size.height/2)
            mushroom2.physicsBody?.isDynamic = false
            mushroom2.physicsBody?.categoryBitMask = vitalyCategory
            mushroom2.physicsBody?.node?.name = "mush2"
            pipePair.addChild(mushroom2)
        } else {
            let mushroom1 = SKSpriteNode(texture: mushroom1Texture)
            mushroom1.setScale(1)
            mushroom1.position = CGPoint(x: 0.0, y: y + Double(mushroom1.size.height) + 5)
            mushroom1.physicsBody = SKPhysicsBody(circleOfRadius: mushroom1.size.height/2)
            mushroom1.physicsBody?.isDynamic = false
            mushroom1.physicsBody?.categoryBitMask = vitalyCategory
            mushroom1.physicsBody?.node?.name = "mush1"
            pipePair.addChild(mushroom1)
        }
        
        let contactNode = SKNode()
        contactNode.position = CGPoint( x: landFly.size.width + bird.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: landFly.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = "Score: \(score)"
        jumpCount = 15
        // Restart animation
        moving.speed = 1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDead else {
            return
        }
        if moving.speed > 0  {
            for _ in touches { // do we need all touches?
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
                jumpCount -= 1
            }
        } else if canRestart {
            self.resetScene()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if jumpCount <= 0 {
            moving.speed = 0
            isDead = true
            if let block = self.dieBlock {
                block(self.score)
            }
            jumpCount = 15
            bird.physicsBody?.collisionBitMask = worldCategory
            bird.run(  SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(bird.position.y) * 0.03, duration:1), completion:{self.bird.speed = 0 })
            // Flash background if contact is detected
            self.removeAction(forKey: "flash")
            self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                self.backgroundColor = self.skyColor
            }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                self.canRestart = true
            })]), withKey: "flash")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "mush1" {
            contact.bodyB.node?.removeFromParent()
            jumpCount += 4
        } else if contact.bodyB.node?.name == "mush2" {
            contact.bodyB.node?.removeFromParent()
            jumpCount -= 2
        } else {
            if moving.speed > 0 {
                if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                    // Bird has contact with score entity
                    score += 1
                    scoreLabelNode.text = "Score: \(score)"
                    
                    // Add a little visual feedback for the score increment
                    scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
                } else {
                    isDead = true
                    if let block = self.dieBlock {
                        block(self.score)
                    }
                    moving.speed = 0
                    
                    bird.physicsBody?.collisionBitMask = worldCategory
                    self.bird.speed = 0
                    // Flash background if contact is detected
                    self.removeAction(forKey: "flash")
                    self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                        self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                    }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                        self.backgroundColor = self.skyColor
                    }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                        self.canRestart = true
                    })]), withKey: "flash")
                }
            }
        }
       
    }
}
