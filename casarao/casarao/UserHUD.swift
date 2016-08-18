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
    
    
    
    var userExpirience: Int
    
    var userCoins:Int
    
    var coinsLabel:SKLabelNode!
    
    var experienceSprite:SKSpriteNode!
    
    
    
    
    init(player:Player){
        userCoins = player.coins!
        userExpirience = 10
        super.init(texture: nil, color: SKColor.blueColor(), size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 25))
    
       coinsLabel = SKLabelNode(text: String(player.coins!))
        coinsLabel.position = CGPoint(x: size.width/2 - 50, y: 0)
        coinsLabel.zPosition += zPosition
        addChild(coinsLabel)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}