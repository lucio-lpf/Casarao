    //
//  GameRoomSpriteNode.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 01/08/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit




class GameRoomSpriteNode: SKSpriteNode{
    
    
    var gameRoom: GameRoom
    
    init(gameRoom:GameRoom,scene:LobbyScene){
        
        self.gameRoom = gameRoom
        super.init(texture: SKTexture(imageNamed:"gameRoomCell"), color: SKColor.clearColor(), size: CGSize(width: scene.size.width - 20, height: 50))
        let number = SKLabelNode(text: gameRoom.roomName)
        number.fontName = "AvenirNext-Bold"
        number.fontSize = 16
        number.fontColor = SKColor.blackColor()
        number.zPosition = 4
        number.verticalAlignmentMode = .Center
        
        let bet = SKLabelNode(text: String(gameRoom.bet))
        bet.fontName = "AvenirNext-Bold"
        bet.fontSize = 16
        bet.fontColor = SKColor.blackColor()
        bet.zPosition = 4
        bet.verticalAlignmentMode = .Center
        
        
        
        let amount = SKLabelNode(text: String(gameRoom.amount))
        amount.fontName = "AvenirNext-Bold"
        amount.fontSize = 16
        amount.fontColor = SKColor.blackColor()
        amount.zPosition = 4
        amount.verticalAlignmentMode = .Center
        
        let numPlayers = SKLabelNode(text: "\(gameRoom.players.count)/\(gameRoom.maxPlayers)")
        numPlayers.fontName = "AvenirNext-Bold"
        numPlayers.fontSize = 16
        numPlayers.fontColor = SKColor.blackColor()
        numPlayers.zPosition = 4
        numPlayers.verticalAlignmentMode = .Center
        
        
        
        //locations in node
        
        number.position = CGPoint(x: -self.size.width/2.4, y: 0)
        addChild(number)
        
        bet.position = CGPoint(x: -self.size.width/4.5, y: 0)
        addChild(bet)
        
        
        
        amount.position = CGPoint(x: +self.size.width/4.5, y: 0)
        addChild(amount)
        
        numPlayers.position = CGPoint(x: +self.size.width/2.5, y: 0)
        addChild(numPlayers)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}