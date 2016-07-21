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
    
    
    var profileButton:SKNode?
    var lobbyButton:SKNode?
    var storeButton:SKNode?
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        profileButton = self.childNodeWithName("profileButton") as SKNode!
        lobbyButton = self.childNodeWithName("lobbyButton") as SKNode!
        storeButton = self.childNodeWithName("storeButton") as SKNode!
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        for touch in touches {
            // self = scene ou parent do button
            if (profileButton!.containsPoint(touch.locationInNode(self))) {
                
                if let profileScene = ProfileScene(fileNamed: "ProfileScene") {
                    if(!self.isKindOfClass(ProfileScene)){
                        transitioToScene(profileScene)
                    }
                }
            }
            
            if (lobbyButton!.containsPoint(touch.locationInNode(self))){
                if let lobbyScene = LobbyScene(fileNamed: "LobbyScene") {
                    if(!self.isKindOfClass(LobbyScene)){
                        transitioToScene(lobbyScene)
                    }
                }
            }
            if (storeButton!.containsPoint(touch.locationInNode(self))) {
                if let storeScene = StoreScene(fileNamed: "StoreScene") {
                    if(!self.isKindOfClass(StoreScene)){
                        transitioToScene(storeScene)
                    }
                }
            }
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