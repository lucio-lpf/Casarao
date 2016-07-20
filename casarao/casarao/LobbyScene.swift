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
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let room = GameRoom()
        
        // fake player
        let player = Player()
        player.nickname = "Jogador 1"
        player.coins = 10
        
        var players = Array<Player>()
        players.reserveCapacity(10)
        
        players.append(player)
        
        
        room.roomName = "Sala 1"
        room.bet = 1
        room.players = players
        room.amount = (Double((room.players?.count)!) * room.bet! )
        
        gameRooms.append(room)
        
        
        let roomNode = self.childNodeWithName("gameRoomNode") as! SKSpriteNode
        
        
        let roomName = roomNode.childNodeWithName("roomName") as! SKLabelNode
        let bet = roomNode.childNodeWithName("bet") as! SKLabelNode
        let numPlayers = roomNode.childNodeWithName("numPlayers") as! SKLabelNode
        let amount = roomNode.childNodeWithName("amount") as! SKLabelNode
        let joinGame = roomNode.childNodeWithName("joinGameNode") as SKNode!
        
        
        
        roomName.text = "\(gameRooms[0].roomName!)"
        bet.text = "$\(gameRooms[0].bet!)"
        amount.text = "$\(gameRooms[0].amount!)"
        numPlayers.text = "\(gameRooms[0].players!.count) / \(gameRooms[0].players!.capacity)"
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
}