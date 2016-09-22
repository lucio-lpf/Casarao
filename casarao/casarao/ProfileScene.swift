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
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button"), color: SKColor.clear, size: CGSize(width: 110, height: 110 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        loginButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clear, size: CGSize(width: 300, height: 70))
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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let userImage = SKSpriteNode(texture: SKTexture(imageNamed:"ProfilePlaceHolder"), color: SKColor.clear, size: CGSize(width: 183, height: 183))
        userImage.position = CGPoint(x: 0, y: size.height/2 - userImage.size.height/2 - 50)
        addChild(userImage)
        
        
       //  meio da tela
        let centerX = (view.bounds.width / 2 - 160)
        let centerY = (view.bounds.height / 2 - 22.5)
        
        highScoreText = UITextField(frame: CGRect(x: centerX, y: (centerY - centerY), width: 320, height: 45))
        
        highScoreText.borderStyle = UITextBorderStyle.roundedRect
        highScoreText.textColor = UIColor.black
        highScoreText.placeholder = "Enter your nickname here"
        highScoreText.backgroundColor = UIColor.white
        highScoreText.autocorrectionType = UITextAutocorrectionType.yes
        highScoreText.keyboardType = UIKeyboardType.default
        highScoreText.clearButtonMode = UITextFieldViewMode.whileEditing
        highScoreText.autocapitalizationType = UITextAutocapitalizationType.words
        highScoreText.returnKeyType = UIReturnKeyType.done
        highScoreText.delegate = self
        highScoreText.isHidden = true
        self.view!.addSubview(highScoreText)
        
        configItemPosition()
    }
    
    
    
    func configItemPosition() {
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        
        // goto: store
        if storeButton.contains(point) {
            
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let scene:StoreScene = StoreScene(size: self.size)
            scene.player = player
            self.view?.presentScene(scene, transition: transition)
            
        }
        // goto: lobby
        else if lobbyButton.contains(point){
            
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let scene:LobbyScene = LobbyScene(size: self.size)
            scene.player = player
            self.view?.presentScene(scene, transition: transition)
        }
        // update user data
        else if loginButton.contains(point) {
           updateLoginUser()
        }
    }
    
    func reloadGameRooms(){
    }
    
    
    func updateLoginUser() {
        highScoreText.isHidden = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Update view
        playerNickname?.text = highScoreText.text
        // Update model
        player?.nickname = highScoreText.text
        
        // Hides the keyboard
        textField.resignFirstResponder()
        highScoreText.isHidden = true
        
        return true
    }
    
    fileprivate func transitioToScene(_ scene:SKScene) {
        let transition = SKTransition.crossFade(withDuration: 0.5)
        // Configure the view.
        let skView = self.view!
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene, transition: transition)
        
    }
}
