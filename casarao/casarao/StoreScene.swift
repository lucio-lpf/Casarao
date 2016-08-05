//
//  StoreScene.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/20/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit



class StoreScene: SKScene {
    
    
    var profileButton:SKSpriteNode!
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loginButton:SKSpriteNode!
    
    var player: Player?
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(profileButton)
        
        addChild(lobbyButton)
        
        addChild(storeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if profileButton.containsPoint(point){
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = ProfileScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        else if lobbyButton.containsPoint(point){
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = LobbyScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    
    private func transitioToScene(scene:SKScene) {
        
        let transition = SKTransition.crossFadeWithDuration(0.5)
        // Configure the view.
        let skView = self.view!
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene, transition: transition)
        
    }
}