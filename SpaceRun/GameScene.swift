//
//  GameScene.swift
//  SpaceRun
//
//  Created by Eric Goettl on 11/30/16.
//  Copyright © 2016 Eric Goettl. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let SpaceshipNodeName = "ship"
    private let PhotonTorpedoNodeName = "photon"
    private let ObstacleNodeName = "obstacle"
    private let PowerupNodeName = "powerup"
    private let HUDNodeName = "hud"
    private let HealthPowerUpNodeName = "health"
    private let ShipShieldNodeName = "shield"
   
    
    private let shootSound: SKAction = SKAction.playSoundFileNamed("laserShot.wav", waitForCompletion: false)
    
    private let obstacleExplodeSound: SKAction = SKAction.playSoundFileNamed("darkExplosion.wav", waitForCompletion: false)
    
    private let shipExplodeSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)

    
    private weak var shipTouch: UITouch?
    private var lastUpdateTime: TimeInterval = 0
    private var lastShotFireTime: TimeInterval = 0
    
    private let defaultFireRate: Double = 0.5
    private var shipFireRate: Double = 0.5
    private let powerupDuration: TimeInterval = 5.0
    private var shipHealthRate: Double = 2.0
    private var currentLevel: Int = 1
    private var dropRate: UInt32 = 15
   
    
    
    
    private let obstacleExplodeTemplate: SKEmitterNode = SKEmitterNode.pdc_nodeWithFile("obstacleExplode.sks")!
    
    private let shipExplodeTemplate: SKEmitterNode = SKEmitterNode.pdc_nodeWithFile("shipExplode.sks")!
    
    override init(size: CGSize) {
        super.init(size: size)
        setupGame(size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupGame(_ size: CGSize) {
        
        let ship = SKSpriteNode(imageNamed: "Spaceship.png")
        
        ship.position = CGPoint(x: size.width/2.0 , y: size.height/2.0)
        
        
        ship.size = CGSize(width: 40.0, height: 40.0)
        
        ship.name = SpaceshipNodeName
        
        addChild(ship)
        
        
        
        addChild(StarField())
        
        
 
        if let shipThruster = SKEmitterNode.pdc_nodeWithFile("shipThruster.sks") {
            
            shipThruster.position = CGPoint(x: 0.0, y: -22.0)
            
         
            ship.addChild(shipThruster)
            
        }
        
     
        let shipShield  = SKSpriteNode(imageNamed: "shield.png")
        
        shipShield.size = CGSize(width: 60.0, height: 60.0)
        
        shipShield.name = ShipShieldNodeName
        
        addChild(shipShield)
        
        shipShield.alpha = CGFloat(shipHealthRate * 0.20)
        
        shipShield.position = ship.position
        
        shipShield.zPosition = 20;
      
        let hudNode = HUDNode()
        
        hudNode.name = HUDNodeName
    
        hudNode.zPosition = 100.0
        
        hudNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        
        
        addChild(hudNode)
        
        
        hudNode.layoutForScene()
        
        hudNode.startGame()
        
        if let hud = self.childNode(withName: self.HUDNodeName)as! HUDNode? {
            
            hud.showHealth(Int(shipHealthRate))
            
        }
        
    }
    override func didMove(to view: SKView) {
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            
            self.shipTouch = touch
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
       
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        
        let timeDelta = currentTime - lastUpdateTime
        
        
        if let shipTouch = self.shipTouch {
            
            moveShipTowardPoint(shipTouch.location(in: self), timeDelta: timeDelta)
            
                if currentTime - lastShotFireTime > shipFireRate {
                shoot()
                
                lastShotFireTime = currentTime
            }
        }
        
        // We want to release obsticles 1.5% of the time a frame is drawn
        // Then multiple that by the level to increase the drop rate
        if arc4random_uniform(1000) <= dropRate * UInt32(currentLevel){
            
            dropThing()
        }
        
        
        checkCollisions()
        
        
        lastUpdateTime = currentTime
    }
    
    
    func moveShipTowardPoint(_ point: CGPoint, timeDelta: TimeInterval) {
        
        
        let shipSpeed = CGFloat(300)
        
        
        if let ship = self.childNode(withName: SpaceshipNodeName) {
            
            
            
            let distanceLeftToTravel = sqrt(pow(ship.position.x - point.x,2) + pow(ship.position.y - point.y, 2))
        
            
            if distanceLeftToTravel > 10 {
                
                
                let howFarToMove = CGFloat(timeDelta) * shipSpeed
                
                
                let angle = atan2(point.y - ship.position.y, point.x - ship.position.x)
                
                
                let xOffset = howFarToMove * cos(angle)
                let yOffset = howFarToMove * sin(angle)
                
                
                ship.position = CGPoint(x: ship.position.x + xOffset, y: ship.position.y + yOffset)
                
                if let shipShield = self.childNode(withName: ShipShieldNodeName) {
                    shipShield.position = ship.position
                }
            }
        }
        
        
    }
    
    func shoot() {
        
        if let ship = self.childNode(withName: SpaceshipNodeName) {
            
           
            let photon = SKSpriteNode(imageNamed: PhotonTorpedoNodeName)
            
            photon.name = PhotonTorpedoNodeName
            
            photon.position = ship.position
            
            self.addChild(photon)
            
            
            let fly = SKAction.moveBy(x: 0, y: self.size.height + photon.size.height, duration: 0.5)
            
            let remove = SKAction.removeFromParent()
            
            let fireAndRemove = SKAction.sequence([fly,remove])
            
            photon.run(fireAndRemove)
            
            self.run(shootSound)
        }
        
    }
    
    func dropThing() {
        
        let dieRoll = arc4random_uniform(100) // die roll between o and 99
        if dieRoll < 10 {
            dropHealth()
        }
        else if dieRoll < 18{
            dropWeaponsPowerUp()
        }
        else if dieRoll < 33 - UInt32(currentLevel){
            dropEnemyShip()
        } else {
            dropAstroid()
        }
    }

    func dropAstroid() {
        
        
        let sideSize = Double(arc4random_uniform(30) + 15)
        
        let maxX = Double(self.size.width)
        let quarterX = maxX / 4.0
        
        let randRange = UInt32(maxX + (quarterX * 2))
        
        
        let startX = Double(arc4random_uniform(randRange)) - quarterX
        
       
        let startY = Double(self.size.height) + sideSize
        
        
        let endX = Double(arc4random_uniform(UInt32(maxX)))
        
        let endY = 0.0 - sideSize
        
        
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        asteroid.size = CGSize(width: sideSize, height: sideSize)
        asteroid.position = CGPoint(x: startX, y: startY)
        
        asteroid.name = ObstacleNodeName
        
        self.addChild(asteroid)
        
        let move = SKAction.move(to: CGPoint(x: endX, y: endY), duration: Double(arc4random_uniform(4) + 3))
        
        let remove = SKAction.removeFromParent()
        
        let travelAndRemove = SKAction.sequence([move, remove])
        
        let spin = SKAction.rotate(byAngle: 3, duration: Double(arc4random_uniform(3) + 1))
        
        let spinForever = SKAction.repeatForever(spin)
        
        let all = SKAction.group([travelAndRemove, spinForever])
        
        asteroid.run(all)
    }
    
    func dropHealth() {
        
        let sideSize = 20.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let shipHealth = SKSpriteNode(imageNamed: HealthPowerUpNodeName)
        
        shipHealth.size = CGSize(width: sideSize, height: sideSize)
        
        shipHealth.position = CGPoint(x: startX, y: startY)
        
        shipHealth.name = HealthPowerUpNodeName
        
        self.addChild(shipHealth)
        
        let shipHealthPath = buildMovementPath()
        
        let followPath = SKAction.follow(shipHealthPath, asOffset: true, orientToPath: true, duration: 5.0)
        
        let scaleDown = SKAction.scale(by: 0.5, duration: 5.0)
        
        let fadeOut = SKAction.fadeOut(withDuration: 5.0)
        
        let group = SKAction.group([followPath, scaleDown, fadeOut])
        
        shipHealth.run(SKAction.sequence([group, SKAction.removeFromParent()]))
        
    }
    func dropWeaponsPowerUp() {
        
        let sideSize = 30.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let powerUp = SKSpriteNode(imageNamed: PowerupNodeName)
        
        powerUp.size = CGSize(width: sideSize, height: sideSize)
        
        powerUp.position = CGPoint(x: startX, y: startY)
        
        powerUp.name = PowerupNodeName
        
        self.addChild(powerUp)
        
    
        let powerUpPath = buildMovementPath()
    
        let followPath = SKAction.follow(powerUpPath, asOffset: true, orientToPath: true, duration: 7.0)
        
        powerUp.run(SKAction.sequence([followPath, SKAction.removeFromParent()]))
        
    }

    func dropEnemyShip() {
        
        let sideSize = 30.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 40)) + 20)
        
        let startY = Double(self.size.height) + sideSize
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        enemy.size = CGSize(width: sideSize, height: sideSize)
        
        enemy.position = CGPoint(x: startX, y: startY)
        
        enemy.name = ObstacleNodeName
        
        self.addChild(enemy)
        
        let shipPath = buildMovementPath()
        
        let followPath = SKAction.follow(shipPath, asOffset: true, orientToPath: true, duration: 7.0)
        
        enemy.run(SKAction.sequence([followPath, SKAction.removeFromParent()]))
        
    }
    
    func buildMovementPath() -> CGPath{
        
        let yMax = -1.0 * self.size.height
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0.5, y: -0.5))
        
        bezierPath.addCurve(to: CGPoint(x: -2.5, y: -59.5), controlPoint1: CGPoint(x: 0.5, y: -0.5), controlPoint2: CGPoint(x: 4.55, y: -29.48))
        
        bezierPath.addCurve(to: CGPoint(x: -27.5, y: -154.5), controlPoint1: CGPoint(x: -9.55, y: -89.52), controlPoint2: CGPoint(x: -43.32, y: -115.43))
        
        bezierPath.addCurve(to: CGPoint(x: 30.5, y: -243.5), controlPoint1: CGPoint(x: -11.68, y: -193.57), controlPoint2: CGPoint(x: 17.28, y: -186.95))
        
        bezierPath.addCurve(to: CGPoint(x: -52.5, y: -379.5), controlPoint1: CGPoint(x: 43.72, y: -300.05), controlPoint2: CGPoint(x: -47.71, y: -335.76))
        
        bezierPath.addCurve(to: CGPoint(x: 54.5, y: -449.5), controlPoint1: CGPoint(x: -57.29, y: -423.24), controlPoint2: CGPoint(x: -8.14, y: -482.45))
        
        bezierPath.addCurve(to: CGPoint(x: -5.5, y: -348.5), controlPoint1: CGPoint(x: 117.14, y: -416.55), controlPoint2: CGPoint(x: 52.25, y: -308.62))
        
        bezierPath.addCurve(to: CGPoint(x: 10.5, y: -494.5), controlPoint1: CGPoint(x: -63.25, y: -388.38), controlPoint2: CGPoint(x: -14.48, y: -457.43))
        
        bezierPath.addCurve(to: CGPoint(x: 0.5, y: -559.5), controlPoint1: CGPoint(x: 23.74, y: -514.16), controlPoint2: CGPoint(x: 6.93, y: -537.57))
        
        //bezierPath.addCurveToPoint(CGPointMake(-2.5, -644.5), controlPoint1: CGPointMake(-5.2, -578.93), controlPoint2: CGPointMake(-2.5, -644.5))
        
        bezierPath.addCurve(to: CGPoint(x: -2.5, y: yMax), controlPoint1: CGPoint(x: -5.2, y: yMax), controlPoint2: CGPoint(x: -2.5, y: yMax))

        return bezierPath.cgPath
        
    }
    
    func checkCollisions() {
        
        if let ship = self.childNode(withName: SpaceshipNodeName), let shipShield = self.childNode(withName: ShipShieldNodeName) {
            
            enumerateChildNodes(withName: PowerupNodeName) {
                myPowerUp, _ in
                
                    if ship.intersects(myPowerUp) {
                    
                    if let hud = self.childNode(withName: self.HUDNodeName)as! HUDNode? {
                        
                        hud.showPowerupTimer(self.powerupDuration)
                        
                        
                    }
                    
                    myPowerUp.removeFromParent()
                    
                    
                    self.shipFireRate = 0.1
                    
                    //Pulse yellow to show power up state
                    let pulseYellow = SKAction.sequence([SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.2), SKAction.wait(forDuration: 0.1), SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)])
                    
                    ship.run(SKAction.repeat(pulseYellow, count: 10))
                    
                   
                    let powerDown = SKAction.run {
                        self.shipFireRate = self.defaultFireRate
                    }
                    
                    let wait = SKAction.wait(forDuration: self.powerupDuration)
                    
                    let waitAndPowerDown = SKAction.sequence([wait,powerDown])
                    
                    let powerDownKey = "waitAndPowerDown"
                    ship.removeAction(forKey: powerDownKey)
                    ship.run(waitAndPowerDown, withKey: powerDownKey)
                    
                }
            }
            enumerateChildNodes(withName: HealthPowerUpNodeName) {
                myHealthUps, _ in
                
                if ship.intersects(myHealthUps) {
                    myHealthUps.removeFromParent()
                    self.shipHealthRate = 4.0
                    
                    if let hud = self.childNode(withName: self.HUDNodeName)as! HUDNode? {
                        
                        hud.showHealth(Int(self.shipHealthRate))
                        
                        
                    }
                    shipShield.alpha = CGFloat(self.shipHealthRate * 0.20)
                    
                }
            }
            
            enumerateChildNodes(withName: ObstacleNodeName) {
                myObstacle, _ in
                
                // check for collision with our ship
                if ship.intersects(myObstacle) {
                    self.shipHealthRate-=1.0
                    shipShield.alpha = CGFloat(self.shipHealthRate * 0.20)
                    myObstacle.removeFromParent()
                    if let hud = self.childNode(withName: self.HUDNodeName)as! HUDNode? {
                        
                        hud.showHealth(Int(self.shipHealthRate))
                        
                    }
                    
                    //Give the player a visual warning of low health
                    if self.shipHealthRate == 1 {
                        
                        let pulseRed = SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2), SKAction.wait(forDuration: 0.1), SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)])
                        
                        ship.run(SKAction.repeat(pulseRed, count: 5))
                        shipShield.alpha = CGFloat(0.0)
                    }
                    
                    if self.shipHealthRate == 0.0 {
                        
                        
                        ship.removeFromParent()
                        self.run(self.shipExplodeSound)
                        
                        let explosion = self.shipExplodeTemplate.copy()as! SKEmitterNode
                        
                        explosion.position = ship.position
                        explosion.pdc_dieOutInDuration(0.3)
                        self.addChild(explosion)
                        
                    }
                }
                
                
                self.enumerateChildNodes(withName: self.PhotonTorpedoNodeName) {
                    myPhoton, stop in
                    
                    if myPhoton.intersects(myObstacle) {
                        
                        
                        myPhoton.removeFromParent()
                        myObstacle.removeFromParent()
                        self.run(self.obstacleExplodeSound)
                        let explosion = self.obstacleExplodeTemplate.copy()as! SKEmitterNode
                        
                        explosion.position = myObstacle.position
                        explosion.pdc_dieOutInDuration(0.1)
                        self.addChild(explosion)
                        
                        //Update our score and level
                        if let hud = self.childNode(withName: self.HUDNodeName)as! HUDNode? {
                            
                            self.currentLevel = hud.addPoints(10)
                            
                            
                        }
                        
                        
                        // stop memory to end this inner loop
                        stop.pointee = true // like a break statement in other languages
                    }
                }
            }
        }
    }
}
