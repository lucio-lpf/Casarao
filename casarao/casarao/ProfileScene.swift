//
//  ProfileScene.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/20/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit
import Parse


class ProfileScene: SKScene {
    
    
    var profileButton:SKNode?
    var lobbyButton:SKNode?
    var storeButton:SKNode?
    
    var player: Player?
    
    var playerNickname:SKLabelNode?
    var playerCoins:SKLabelNode?
    
    
    
    override init() {
        super.init()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        if let pfuser = PFUser.currentUser() {
            self.player = Player(pfuser: pfuser)
        }
        
        
        profileButton = self.childNodeWithName("profileButton") as SKNode!
        lobbyButton = self.childNodeWithName("lobbyButton") as SKNode!
        storeButton = self.childNodeWithName("storeButton") as SKNode!
        
        configItemPosition()
    }
    
    
    
    func configItemPosition() {
        
        
        guard let coins = player?.coins else {fatalError()}
        guard let nickname = player?.nickname else {fatalError()}
        
        playerNickname = SKLabelNode(fontNamed: "AppleSDGothicNeo-Regular ")
        playerNickname?.text = nickname
        playerNickname?.color = UIColor.blackColor()
        playerNickname?.position = CGPoint(x: 50, y: 50)
        
        self.addChild(playerNickname!)
        
        
        playerCoins = SKLabelNode(fontNamed: "AppleSDGothicNeo-Regular ")
        playerCoins?.text = coins.description
        playerCoins?.color = UIColor.blackColor()
        playerCoins?.position = CGPoint(x: 100, y: 100)
        
        self.addChild(playerCoins!)
        
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        for touch in touches {
            
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