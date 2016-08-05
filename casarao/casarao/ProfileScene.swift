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
    
    
    var profileButton:SKSpriteNode!
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loginButton:SKSpriteNode!
    
    var player: Player?
    
    var playerNickname:SKLabelNode?
    var playerCoins:SKLabelNode?
    var profileImage:SKSpriteNode?
    
    
    
    
    
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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        if let pfuser = PFUser.currentUser() {
            self.player = Player(pfuser: pfuser)
        }
        
        configItemPosition()
    }
    
    
    
    func configItemPosition() {
        guard let coins = player?.coins else {fatalError()}
        guard let nickname = player?.nickname else {fatalError()}
        guard let profileImageData = player?.image else {fatalError()}
        
        let offset: CGFloat = 20.0
        
        let top = self.size.height/2
        
        playerNickname = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playerNickname?.text = nickname
        playerNickname?.fontSize = 24
        playerNickname?.position = CGPoint(x: 0, y: +top - (playerNickname?.frame.height)! - offset)
        
        self.addChild(playerNickname!)
        
        
        playerCoins = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playerCoins?.text = "$ \(coins.description)"
        playerCoins?.fontSize = 18
        playerCoins?.position = CGPoint(x: 0, y: (+top - (playerNickname?.frame.height)! - (playerCoins?.frame.height)!)-offset-offset)
        
        self.addChild(playerCoins!)
        
        let image = UIImage(data:profileImageData)!
        let texture = SKTexture(image:image)
        
        profileImage = SKSpriteNode(texture:texture)
        
        let playerNickameHeight = (playerNickname?.frame.height)!
        let playerCoinsHeight = (playerCoins?.frame.height)!
        let plus = playerCoinsHeight + playerNickameHeight
        let minus3Offset = offset + offset + offset
        
        let imageSize = (profileImage?.frame.height)!/2
        
        profileImage?.position = CGPoint(x: 0, y: +top - imageSize - plus - minus3Offset)
        
        
//        self.addChild(profileImage!)
        
        
        
        loginButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clearColor(), size: CGSize(width: 300, height: 70))
        loginButton.position = CGPoint(x: 0.5, y: 0.5)
        addChild(loginButton)
        
        
        
        
//        let shape = SKShapeNode()
//        shape.path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 64).CGPath
//        shape.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
//        shape.fillColor = UIColor.redColor()
//        shape.strokeColor = UIColor.blueColor()
//        shape.lineWidth = 10
//        addChild(shape)
        
        
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if profileButton.containsPoint(point){
            
            
            reloadGameRooms()
            
        }
        else if storeButton.containsPoint(point){
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = StoreScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
            
        }
        else if lobbyButton.containsPoint(point){
            
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = LobbyScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        
        else if loginButton.containsPoint(point) {
           updateLoginUser()
        }
    }
    
    func reloadGameRooms(){
    }
    
    
    func updateLoginUser() {
        print("new user")
        
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