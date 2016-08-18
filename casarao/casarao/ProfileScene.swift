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


class ProfileScene: SKScene, UITextFieldDelegate {
    
    
    var profileButton:SKSpriteNode!
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loginButton:SKSpriteNode!
    
    var player: Player?
    
    var playerNickname:SKLabelNode?
    var playerCoins:SKLabelNode?
    var profileImage:SKSpriteNode?
    
    var highScoreText:UITextField!
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        loginButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clearColor(), size: CGSize(width: 300, height: 70))
        loginButton.position = CGPoint(x: 0.5, y: 0.5)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(profileButton)
        
        addChild(lobbyButton)
        
        addChild(storeButton)
        
        addChild(loginButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let userImage = SKSpriteNode(texture: SKTexture(imageNamed:"ProfilePlaceHolder"), color: SKColor.clearColor(), size: CGSize(width: 183, height: 183))
        userImage.position = CGPoint(x: 0, y: size.height/2 - userImage.size.height/2 - 50)
        addChild(userImage)
        
        
       //  meio da tela
        let centerX = (view.bounds.width / 2 - 160)
        let centerY = (view.bounds.height / 2 - 22.5)
        
        highScoreText = UITextField(frame: CGRectMake(centerX, (centerY - centerY), 320, 45))
        
        highScoreText.borderStyle = UITextBorderStyle.RoundedRect
        highScoreText.textColor = UIColor.blackColor()
        highScoreText.placeholder = "Enter your nickname here"
        highScoreText.backgroundColor = UIColor.whiteColor()
        highScoreText.autocorrectionType = UITextAutocorrectionType.Yes
        highScoreText.keyboardType = UIKeyboardType.Default
        highScoreText.clearButtonMode = UITextFieldViewMode.WhileEditing
        highScoreText.autocapitalizationType = UITextAutocapitalizationType.Words
        highScoreText.returnKeyType = UIReturnKeyType.Done
        highScoreText.delegate = self
        highScoreText.hidden = true
        self.view!.addSubview(highScoreText)
        
        configItemPosition()
    }
    
    
    
    func configItemPosition() {
        
        
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        
        // goto: store
        if storeButton.containsPoint(point) {
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = StoreScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
            
        }
        // goto: lobby
        else if lobbyButton.containsPoint(point){
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = LobbyScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        // update user data
        else if loginButton.containsPoint(point) {
           updateLoginUser()
        }
    }
    
    func reloadGameRooms(){
    }
    
    
    func updateLoginUser() {
        highScoreText.hidden = false
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Update view
        playerNickname?.text = highScoreText.text
        // Update model
        player?.nickname = highScoreText.text
        
        // Hides the keyboard
        textField.resignFirstResponder()
        highScoreText.hidden = true
        
        return true
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