//
//  SKEmitterNodeExtension.swift
//  SpaceRun
//
//  Created by Eric Goettl on 12/14/16.
//  Copyright © 2016 Eric Goettl. All rights reserved.
//

import SpriteKit

// Use a swift extension to extend the String class
// to have a length property
extension String {
    
    var length: Int {
        
        return self.characters.count
        
    }
}

extension SKEmitterNode {
    
    //Helper class method to find and fetch the 
    //passed in particle effect file.
    
    class func pdc_nodeWithFile(_ filename: String) -> SKEmitterNode? {
        
        // We will check filename's basename and extension.  If their
        // is no extension, we will set it to "sks"
        let basename = (filename as NSString).deletingPathExtension
        
        // get the file's extension if it has one
        var fileExt = (filename as NSString).pathExtension
        
        if fileExt.length == 0 {
            fileExt = "sks"
        }
        
        // We will grab the main bundle of our project and ask for the path
        // to a resource that has the calculated basename and extension.
        if let path = Bundle.main.path(forResource: basename, ofType: fileExt) {
            
            // Particle effects in SpriteKit are archieved when created
            // and we need to unarchieve the effect file so it can be
            // treated as a SKEMitterNode object.
            let node = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! SKEmitterNode
            return node
            
        }
        
        return nil
    }
 
    func pdc_dieOutInDuration(_ duration: TimeInterval) {
        
        let firstWait = SKAction.wait(forDuration: duration)
        
        // Set the birth rate to zero using a code block
        
        let stop = SKAction.run{
            [weak self] in
            
            if let weakSelf = self{
                weakSelf.particleBirthRate = 0
            }
            
        }
        
        let secondWait = SKAction.wait(forDuration: TimeInterval(self.particleLifetime))
        
        run(SKAction.sequence([firstWait, stop, secondWait, SKAction.removeFromParent()]))
        
    }
}
