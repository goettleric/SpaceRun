//
//  HUDNode.swift
//  SpaceRun
//
//  Created by Eric Goettl on 12/12/16.
//  Copyright © 2016 Eric Goettl. All rights reserved.
//

import SpriteKit


class HUDNode: SKNode {

   
    private let ScoreGroupName = "scoreGroup"
    private let ScoreValueName = "scoreValue"
    
    private let ElapsedGroupName = "elapsedGroup"
    private let ElapsedValueName = "elapsedValue"
    private let TimerActionName = "elapsedGameTimer"
    
    private let HealthGroupName = "healthGroup"
    private let HealthValueName = "healthValue"
    private let HealthBarName = "healthBar"
    
    private let PowerUpGroupName = "powerupGroup"
    private let PowerUpValueName = "powerupValue"
    private let PowerUpTimerActionName = "powerupGameTimer"
    
    private let LevelGroupName = "levelGroup"
    private let LevelValueName = "levelValue"
    
    var elapsedTime: TimeInterval = 0.0
    var score: Int = 0
    var health: Int = 0
    var currentLevel: Int = 1
    
    lazy private var scoreFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
        
    }()
    
    lazy private var TimeFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
        
    }()
    
    override init() {
        
        super.init()
        
        let scoreGroup = SKNode()
        
        scoreGroup.name = ScoreGroupName
        
        let scoreTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        scoreTitle.fontSize = 12.0
        scoreTitle.fontColor = SKColor.white
        
        scoreTitle.horizontalAlignmentMode = .left
        scoreTitle.verticalAlignmentMode = .bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPoint(x: 0.0, y: 4.0)

        scoreGroup.addChild(scoreTitle)
        
        let scoreValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        scoreValue.fontSize = 20.0
        scoreValue.fontColor = SKColor.white
        
        scoreValue.horizontalAlignmentMode = .left
        scoreValue.verticalAlignmentMode = .top
        scoreValue.name = ScoreValueName
        scoreValue.text = "0"
        scoreValue.position = CGPoint(x: 0.0, y: -4.0)
        
        scoreGroup.addChild(scoreValue)
        
        addChild(scoreGroup)
        
        let healthGroup = SKNode()
        
        healthGroup.name = HealthGroupName
        
        let healthTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        healthTitle.fontSize = 12.0
        healthTitle.fontColor = SKColor.white
        
        healthTitle.horizontalAlignmentMode = .center
        healthTitle.verticalAlignmentMode = .bottom
        healthTitle.text = "HEALTH"
        healthTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        healthGroup.addChild(healthTitle)
        
        let healthValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        healthValue.fontSize = 10.0
        healthValue.fontColor = SKColor.white
        
        healthValue.horizontalAlignmentMode = .center
        healthValue.verticalAlignmentMode = .top
        healthValue.name = HealthValueName
        healthValue.text = "0"
        healthValue.position = CGPoint(x: 0.0, y: -4.0)
        
        healthGroup.addChild(healthValue)
        
        let healthBar = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 3))
        
        healthBar.position = CGPoint(x: 0.0, y: -22.0)
        
        healthBar.name = HealthBarName
        
        healthGroup.addChild(healthBar)
       
        addChild(healthGroup)

        
        
        let elapsedGroup = SKNode()
        
        elapsedGroup.name = ElapsedGroupName
        
        let elapsedTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        elapsedTitle.fontSize = 12.0
        elapsedTitle.fontColor = SKColor.white
        
        elapsedTitle.horizontalAlignmentMode = .right
        elapsedTitle.verticalAlignmentMode = .bottom
        elapsedTitle.text = "TIME"
        elapsedTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        elapsedGroup.addChild(elapsedTitle)
        
        let elapsedValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        elapsedValue.fontSize = 20.0
        elapsedValue.fontColor = SKColor.white
        
        elapsedValue.horizontalAlignmentMode = .right
        elapsedValue.verticalAlignmentMode = .top
        elapsedValue.name = ElapsedValueName
        elapsedValue.text = "0.0s"
        elapsedValue.position = CGPoint(x: 0.0, y: -4.0)
        
        elapsedGroup.addChild(elapsedValue)
        
        addChild(elapsedGroup)
        
        
        let powerupGroup = SKNode()
        
        powerupGroup.name = PowerUpGroupName
        let powerupTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        powerupTitle.fontSize = 14.0
        powerupTitle.fontColor = SKColor.red
        
        
        powerupTitle.verticalAlignmentMode = .bottom
        powerupTitle.text = "Power-up!"
        powerupTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        powerupGroup.addChild(powerupTitle)
        
        powerupTitle.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.3), SKAction.scale(to: 1.0, duration: 0.3)])))
        
        let powerupValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        powerupValue.fontSize = 20.0
        powerupValue.fontColor = SKColor.red
        
        
        powerupValue.verticalAlignmentMode = .top
        powerupValue.name = PowerUpValueName
        powerupValue.text = "0s left"
        powerupValue.position = CGPoint(x: 0.0, y: -4.0)
        
        powerupGroup.addChild(powerupValue)
        
        
        addChild(powerupGroup)

        
        powerupGroup.alpha = 0.0
        
        let levelGroup = SKNode()
        
        levelGroup.name = LevelGroupName
        let levelTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        
        levelTitle.fontSize = 14.0
        levelTitle.fontColor = SKColor.red
        
        levelTitle.horizontalAlignmentMode = .center
        levelTitle.verticalAlignmentMode = .bottom
        levelTitle.text = "LEVEL"
        levelTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        levelGroup.addChild(levelTitle)
        
        let levelValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        
        levelValue.fontSize = 20.0
        levelValue.fontColor = SKColor.red
        
        levelValue.horizontalAlignmentMode = .center
        levelValue.verticalAlignmentMode = .top
        levelValue.name = LevelValueName
        levelValue.text = "1"
        levelValue.position = CGPoint(x: 0.0, y: -4.0)
        
        levelGroup.addChild(levelValue)
        
        
        addChild(levelGroup)
        
        
        levelGroup.alpha = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layoutForScene() {
        
        
        if let scene = scene {
            
            let sceneSize = scene.size
            
            
            var groupSize = CGSize.zero
            
            if let scoreGroup = childNode(withName: ScoreGroupName) {
                
                groupSize = scoreGroup.calculateAccumulatedFrame().size
                
                scoreGroup.position = CGPoint(x: 0.0 - sceneSize.width/2.0 + 20.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No score group node was found in the Scene Graph tree")
            }
            
            if let healthGroup = childNode(withName: HealthGroupName) {
                
                groupSize = healthGroup.calculateAccumulatedFrame().size
                
                healthGroup.position = CGPoint(x: 0.0, y: -sceneSize.height/2.0 + groupSize.height)
                
            } else {
                assert(false, "No score group node was found in the Scene Graph tree")
            }
            
            
            if let elapsedGroup = childNode(withName: ElapsedGroupName) {
                
                groupSize = elapsedGroup.calculateAccumulatedFrame().size
                
                elapsedGroup.position = CGPoint(x: sceneSize.width/2.0 - 20.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No elapsed group node was found in the Scene Graph tree")
            }
            
            if let powerupGroup = childNode(withName: PowerUpGroupName) {
                
                groupSize = powerupGroup.calculateAccumulatedFrame().size
                
                powerupGroup.position = CGPoint(x: 0.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No elapsed group node was found in the Scene Graph tree")
            }
            
            if let levelGroup = childNode(withName: LevelGroupName) {
                
                groupSize = levelGroup.calculateAccumulatedFrame().size
                
                levelGroup.position = CGPoint(x: 0.0, y: 0.0)
                
            } else {
                assert(false, "No elapsed group node was found in the Scene Graph tree")
            }

            
        }
        
    }
    
    func showPowerupTimer(_ time: TimeInterval) {
        
        
        if let powerupGroup = childNode(withName: PowerUpGroupName) {
            
            powerupGroup.removeAction(forKey: PowerUpTimerActionName)
            
            if let powerupValue = powerupGroup.childNode(withName: PowerUpValueName) as! SKLabelNode? {
                
                let start = Date.timeIntervalSinceReferenceDate
                
                let block = SKAction.run{
                    [weak self] in
                    
                    if let weakSelf = self {
                        
                        let elapseTime = Date.timeIntervalSinceReferenceDate - start
                        
                        let timeLeft = max(time - elapseTime, 0)
                        
                        let timeLeftFormat = weakSelf.TimeFormatter.string(from: NSNumber(value: timeLeft))!
                        
                        powerupValue.text = "\(timeLeftFormat)s left"
                        
                        
                        
                    }
                
                }
                
                let countDown = SKAction.repeatForever(SKAction.sequence([block, SKAction.wait(forDuration: 0.5)]))
                
                let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
                let wait = SKAction.wait(forDuration: time)
                let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
                let stopAction = SKAction.run({ () -> Void in
                
                    powerupGroup.removeAction(forKey: self.PowerUpTimerActionName)
                
                })
                
                let visuals = SKAction.sequence([fadeIn, wait, fadeOut, stopAction])
                
                powerupGroup.run(SKAction.group([countDown, visuals]), withKey: self.PowerUpTimerActionName)
                
            }
        }
        
    }
    
    func showLevelUp(_ level: Int) {
        
        if let levelGroup = childNode(withName: LevelGroupName) {
            
            
           if let levelValue = levelGroup.childNode(withName: LevelValueName) as! SKLabelNode? {
            
                levelValue.text = String(level)
                
            levelGroup.run(SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 0.1), SKAction.wait(forDuration: 1.0), SKAction.fadeAlpha(to: 0.0, duration: 1.0)]))
            }
        }
        
    }
   
    func addPoints(_ points: Int) -> Int {
        
        score += points
        
        
        if let scoreValue = childNode(withName: "\(ScoreGroupName)/\(ScoreValueName)") as! SKLabelNode? {
            
            
            scoreValue.text = scoreFormatter.string(from: NSNumber(value: score))
            
            
            scoreValue.run(SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.02),SKAction.scale(to: 1.0, duration: 0.07)]))
            
            if score % 200 == 0 {
                currentLevel += 1
                showLevelUp(currentLevel)
            }
        }
        return currentLevel
    }
    
    func showHealth(_ healthPoints: Int) {
        
        health = healthPoints
        
        if let healthValue = childNode(withName: "\(HealthGroupName)/\(HealthValueName)") as! SKLabelNode? {
            
            healthValue.text = String(health)
            if let healthBar = childNode(withName: "\(HealthGroupName)/\(HealthBarName)") as! SKSpriteNode? {
                
                healthBar.scale(to: CGSize(width: Double(health) * 30, height: 3))
                
                if health == 4 {
                    healthBar.color = .green
                } else if health >= 2 {
                    healthBar.color = .yellow
                } else {
                    healthBar.color = .red
                }
                
            }
        }
        
    }
    
    func startGame() {
        
        
        let startTime = Date.timeIntervalSinceReferenceDate
        
        if let elapsedValue = childNode(withName: "\(ElapsedGroupName)/\(ElapsedValueName)") as! SKLabelNode? {
            
           
            let update = SKAction.run({
                [weak self] in
                
                if let weakSelf = self {
                    
                    let currentTime = Date.timeIntervalSinceReferenceDate
                    
                    let elapsedTime = currentTime - startTime
                    weakSelf.elapsedTime = elapsedTime
                    
                    elapsedValue.text = weakSelf.TimeFormatter.string(from: NSNumber(value: elapsedTime))
                    
                }
            
            })
            
            let timer = SKAction.repeatForever(SKAction.sequence([update, SKAction.wait(forDuration: 0.05)]))
            
            run(timer, withKey: TimerActionName)
            
            self.showLevelUp(currentLevel)
        
        }
        
    }
}
