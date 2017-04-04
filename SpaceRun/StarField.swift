//
//  StarField.swift
//  SpaceRun
//
//  Created by Eric Goettl on 12/14/16.
//  Copyright © 2016 Eric Goettl. All rights reserved.
//

import SpriteKit

class StarField: SKNode {

    override init() {
        super.init()
        initSetup()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        initSetup()
    }
    
    func initSetup() {
        
        //Because we need to call a method on self from inside a code block,
        // we must create a weak reference to it... WhY? the SKAction holds a 
        // strong reference to the code block and the node (self) also holds 
        // a strong reference to the action.   If the code block also held a 
        // strong reference to the node (self) then the action, the code block
        // and the node would form a retain cycle, and would never get deallocated.
        // ie memory leak
        
        let update = SKAction.run{
            [weak self] in
            
            if arc4random_uniform(10) < 5 {
                
                if let weakSelf = self {
                    weakSelf.launchStar()
                }
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.01), update])))
    }
    func launchStar() {
     
        // Make sure we have a reference to the scene
        if let scene = self.scene {
            
            // Calculate a random starting point at the top of the screen
            let randX = Double(arc4random_uniform(uint(scene.size.width)))
            
            let maxY = Double(scene.size.height)
            
            let star = SKSpriteNode(imageNamed:"shootingstar")
            
            star.position = CGPoint(x: randX, y: maxY)
            star.alpha  = 0.1 + (CGFloat(arc4random_uniform(10)) / 10.0)
            star.size = CGSize(width: 3.0 - star.alpha, height: 8 - star.alpha)
            
            // stack from dimmest to brightest in the z-axis
            star.zPosition = -100 + star.alpha * 10
            
            // Move the star toward the bottom of the screen using a random 
            // diration between o.8 and 1.7 second.  Removing the star when it passes
            // the bottom edge
            // The different speeds will give the illusion of the parallax effect.
            //
            let destY = 0.0 - scene.size.height - star.size.height
            let duration = Double(-star.alpha + 1.8)
            
            addChild(star)
            
            star.run(SKAction.sequence([SKAction.moveBy(x: 0.0, y: destY, duration: duration), SKAction.removeFromParent()]))
            
        }
        
    }
}
