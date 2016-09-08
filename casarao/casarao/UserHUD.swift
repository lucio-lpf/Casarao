//
//  UserHUD.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 10/08/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit

class UserHUD: SKSpriteNode {
    
     let defaults = NSUserDefaults.standardUserDefaults()
    
    var userExpirience: Int
    
    var userCoins:Int!
    
    var coinsLabel:SKLabelNode!
    
    var experienceSprite:SKSpriteNode!
    
    
    
    
    init(player:Player){
        
        userExpirience = 10
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 25))
        userCoins = player.coins!
        
        let coinsIcon = SKSpriteNode(texture: SKTexture(imageNamed: "coins"), color: SKColor.clearColor(), size: CGSize(width: 30, height: 30))
        coinsIcon.position = CGPoint(x: 25 - size.width/2 , y: -8)
        coinsIcon.zPosition += zPosition
        addChild(coinsIcon)
    
        coinsLabel = SKLabelNode(text: "\(String(defaults.integerForKey("coins")))")
        coinsLabel.fontSize = 16
        coinsLabel.position = CGPoint(x: 90 - size.width/2, y: -8)
        coinsLabel.zPosition += zPosition
        addChild(coinsLabel)
    
    }
    
    
    func updateCoinsLabel(){
          coinsLabel = SKLabelNode(text: "Coins: \(String(defaults.integerForKey("coins")))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}