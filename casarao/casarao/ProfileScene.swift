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
    
    var userHUD:UserHUD!
    
    var tutorialController:Int!
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button"), color: SKColor.clear, size: CGSize(width: 120, height: 120 ))
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
        
        
        userHUD = UserHUD(player: player!)
        userHUD.position = CGPoint(x: 0, y: size.height/2 - userHUD.size.height/2)
        userHUD.zPosition = 200
        addChild(userHUD)
        
        let userImage = SKSpriteNode(texture: SKTexture(imageNamed:"ProfilePlaceHolder"), color: SKColor.clear, size:SKTexture(imageNamed:"ProfilePlaceHolder").size())
        userImage.position = CGPoint(x: 0, y: 180)
        addChild(userImage)
        
        
        playerNickname = SKLabelNode(text: player!.nickname)
        
        playerNickname?.fontSize = 20
        playerNickname?.fontName = "Helvetica Neue"
        
        playerNickname?.position = CGPoint(x:0, y:userImage.position.y - userImage.size.height/2 - 40)
        
        addChild(playerNickname!)
        
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
        
        if tutorialController != nil{
            
            addAlpha()
            let popup = PopUpSpriteNode(tutorialNumber:tutorialController)
            popup.name = "tutorialPopUp"
            popup.position = CGPoint(x:0,y:0)
            popup.zPosition = 1001
            storeButton.zPosition = 1001
            addChild(popup)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        if tutorialController != nil{
            
            
            if storeButton.contains(point){
                let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                let scene:StoreScene = StoreScene(size: self.size)
                scene.tutorialController = tutorialController + 1
                scene.player = player
                self.view?.presentScene(scene, transition: transition)
            }
            return
            
        }
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
    
    
    func addAlpha(){
        let alphaNode = SKSpriteNode(color: UIColor.black, size: self.size)
        alphaNode.alpha = 0.0
        alphaNode.name = "alphaNode"
        alphaNode.isUserInteractionEnabled = true
        alphaNode.zPosition = 53
        self.addChild(alphaNode)
        alphaNode.run(SKAction.fadeAlpha(to: 0.8, duration: 0.15))
    }
    
    func updateLoginUser() {
        addAlpha()
        highScoreText.isHidden = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Update view
        playerNickname?.text = highScoreText.text
        // Update model
        player!.updateNickname(highScoreText.text!) { (bool) in
        
            // Hides the keyboard
            textField.resignFirstResponder()
            self.highScoreText.isHidden = true
            self.childNode(withName: "alphaNode")?.removeFromParent()
            
            
            
        }
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
