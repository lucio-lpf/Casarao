//
//  LobbyScene.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/20/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit
import Parse

class LobbyScene: SKScene, PopUpInLobby {
    
    var gameRooms:Array<GameRoom> = Array()
    
    var profileButton:SKNode?
    var lobbyButton:SKNode?
    var storeButton:SKNode?
    var joinGameButton:SKNode?
    
    
    // REFACTORING
    var player:Player!
    var selectedRoomNode:SKNode?
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        let checkUserPopUp = PopUpSpriteNode()
        
        addChild(checkUserPopUp)
        
        
        
        
        // REFACTORING
       
        //CHECK CURRENT USER
        let allUsersPass = "P6xA5#72GacX;F]X"
        
        // init user
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.player = Player(pfuser: currentUser!)
            self.player.coins = 10
            checkUserPopUp.removeFromParent()
            
        } else {
            PFUser.logInWithUsernameInBackground(String(UIDevice.currentDevice().identifierForVendor!), password: allUsersPass) {
                (pfuser, error) in
                
                if let e = error {
                    print(e.debugDescription)
                    let player = PFUser()
                    player.username = String(UIDevice.currentDevice().identifierForVendor!)
                    player.password = allUsersPass
                    player.email = "\(UIDevice.currentDevice().identifierForVendor!)@teste.com"
                    player.signUpInBackgroundWithBlock(){
                        (bool, error) in
                        if let e = error{
                            print(e.debugDescription)
                        } else {
                            self.player = Player(pfuser: player)
                            self.player.coins = 10
                            checkUserPopUp.removeFromParent()
                        }
                    }
                } else {
                    self.player = Player(pfuser: pfuser!)
                    self.player.coins = 10
                    checkUserPopUp.removeFromParent()
                    
                }
            }
        }
        
        
        
        let roomNode = self.childNodeWithName("gameRoomNode") as! SKSpriteNode
        let roomName = roomNode.childNodeWithName("roomName") as! SKLabelNode
        let bet = roomNode.childNodeWithName("bet") as! SKLabelNode
        let numPlayers = roomNode.childNodeWithName("numPlayers") as! SKLabelNode
        let amount = roomNode.childNodeWithName("amount") as! SKLabelNode
        
        
        
        WebServiceManager.returnGameRooms { (gameRooms) in
            
            self.gameRooms = gameRooms
            print(gameRooms)
            
            roomName.text = "\(gameRooms[0].roomName!)"
            bet.text = "$\(gameRooms[0].bet)"
            amount.text = "$\(gameRooms[0].amount)"
            numPlayers.text = "\(gameRooms[0].players.count) / \(gameRooms[0].maxPlayers)"
            
            
        }
        
        profileButton = self.childNodeWithName("profileButton") as SKNode!
        lobbyButton = self.childNodeWithName("lobbyButton") as SKNode!
        storeButton = self.childNodeWithName("storeButton") as SKNode!
        
        
        
        
        
        
        
        
        // REFACTORING
        selectedRoomNode = roomNode
        
        joinGameButton = roomNode.childNodeWithName("joinGameNode") as SKNode!
        
        
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
            
            if (lobbyButton!.containsPoint(touch.locationInNode(self))) {
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
            
            if selectedRoomNode!.containsPoint(touch.locationInNode(self)) {
                verifyUserCoins()
            }
        }
    }
    
    
    private func verifyUserCoins() {
        if player.coins! >= gameRooms[0].bet {
            joinGame()
        }
    }
    
    
    func joinGame() {
        
        let gameRoom = gameRooms[0]
        
        self.addChild(PopUpSpriteNode(bet: gameRoom.bet, scene: self))
        
        
    }
    
    
    func didDeciedEnterRoom(response: Bool,selfpopUp:PopUpSpriteNode) {
        if response == true{
            
            for player in gameRooms[0].players{
                if player.username ==  self.player!.username{
                    if let gameScene = GameScene(fileNamed: "GameScene") {
                        
                        gameScene.gameRoom = self.gameRooms[0]
                        gameScene.player = self.player
                        transitioToScene(gameScene)
                    }
                }
            }
            
            gameRooms[0].addPlayerToGame(self.player)
            player.coins! -= gameRooms[0].bet
            if let gameScene = GameScene(fileNamed: "GameScene") {
                
                gameScene.gameRoom = self.gameRooms[0]
                gameScene.player = self.player
                transitioToScene(gameScene)
            }
            
            
            
            
        }
        else{
            selfpopUp.removeFromParent()
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



















