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
    
     let defaults = UserDefaults.standard
    
    var userExpirience: Int
    
    var userCoins:Int!
    
    var coinsLabel:SKLabelNode!
    
    var experienceSprite:SKSpriteNode!
    
    
    
    
    init(player:Player){
        
        userExpirience = 10
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: UIScreen.main.bounds.width, height: 50))
        userCoins = player.coins!
        
        let coinsIcon = SKSpriteNode(texture: SKTexture(imageNamed: "coinsIcon"), color: SKColor.clear, size: SKTexture(imageNamed: "coinsIcon").size())
        coinsIcon.position = CGPoint(x: coinsIcon.size.width/2 - size.width/2 + 10 , y: 0)
        coinsIcon.zPosition += zPosition
        addChild(coinsIcon)
    
        coinsLabel = SKLabelNode(text: "\(String(defaults.integer(forKey: "coins")))")
        coinsLabel.fontColor = SKColor.black
        coinsLabel.position = CGPoint(x: coinsIcon.size.width/2 - 20, y: -6)
        coinsLabel.fontSize = 16
        coinsLabel.zPosition = coinsIcon.zPosition + 2
        coinsIcon.addChild(coinsLabel)
    
    }
    
    
    func updateCoinsLabel(){
          coinsLabel = SKLabelNode(text: "Coins: \(String(defaults.integer(forKey: "coins")))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
