//
//  endGamePopUp.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit

class PopUpSpriteNode: SKSpriteNode{
    
    
    var GameSceneDelegate:GameScene?
    var LobbySceneDelegate:LobbyScene?
    
    
    init(bet: Int,scene: LobbyScene){
        super.init(texture: SKTexture(imageNamed: "Sprite") , color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = nil
        self.LobbySceneDelegate = scene

    }
    init(users: Array<Player>,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
    }
    
    
    init(scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
    }
    
    init(winner: Player,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil

    }
    
    init(timer:NSTimer,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}