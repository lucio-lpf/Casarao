//
//  LobbyScene.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/20/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit


class LobbyScene: SKScene {
    
    var gameRooms:Array<GameRoom> = Array()
    
    var profileButton:SKNode?
    var lobbyButton:SKNode?
    var storeButton:SKNode?
    var joinGameButton:SKNode?
    
    
    // REFACTORING
    var selectedRoomNode:SKNode?

    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        profileButton = self.childNodeWithName("profileButton") as SKNode!
        lobbyButton = self.childNodeWithName("lobbyButton") as SKNode!
        storeButton = self.childNodeWithName("storeButton") as SKNode!
        
        
        
        let room = GameRoom()
        
        // fake player
        let player = Player()
        player.nickname = "Fake Player"
        player.coins = 10
        
        var players = Array<Player>()
        players.reserveCapacity(10)
        
        players.append(player)
        
        
        room.roomName = "Sala 1"
        room.bet = 1
        room.players = players
        room.amount = (Double((room.players?.count)!) * room.bet!)
        
        gameRooms.append(room)
        
        
        let roomNode = self.childNodeWithName("gameRoomNode") as! SKSpriteNode
        
        
        let roomName = roomNode.childNodeWithName("roomName") as! SKLabelNode
        let bet = roomNode.childNodeWithName("bet") as! SKLabelNode
        let numPlayers = roomNode.childNodeWithName("numPlayers") as! SKLabelNode
        let amount = roomNode.childNodeWithName("amount") as! SKLabelNode
        
        
        
        // REFACTORING
        selectedRoomNode = roomNode
        
        joinGameButton = roomNode.childNodeWithName("joinGameNode") as SKNode!
        
        roomName.text = "\(gameRooms[0].roomName!)"
        bet.text = "$\(gameRooms[0].bet!)"
        amount.text = "$\(gameRooms[0].amount!)"
        numPlayers.text = "\(gameRooms[0].players!.count) / \(gameRooms[0].players!.capacity)"
        
        
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
                        transitioToScene(profileScene, direction: .Right)
                    }
                }
            }
            
            if (lobbyButton!.containsPoint(touch.locationInNode(self))) {
                if let lobbyScene = LobbyScene(fileNamed: "LobbyScene") {
                    if(!self.isKindOfClass(LobbyScene)){
                        transitioToScene(lobbyScene, direction: .Left)
                    }
                }
            }
            
            if (storeButton!.containsPoint(touch.locationInNode(self))) {
                if let storeScene = StoreScene(fileNamed: "StoreScene") {
                    if(!self.isKindOfClass(StoreScene)){
                        transitioToScene(storeScene, direction: .Left)
                    }
                }
            }
            
            if selectedRoomNode!.containsPoint(touch.locationInNode(self)) {
                verifyUserCoins()
            }
        }
    }
    
    
    func verifyUserCoins() {
        let player = Player.sharedInstance
        if player.coins > Double(gameRooms[0].bet!) {
            
        }
    }
    
    private func transitioToScene(scene:SKScene, direction:SKTransitionDirection ) {
        
//        let transition = SKTransition.revealWithDirection(direction, duration: 1.0)
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



















