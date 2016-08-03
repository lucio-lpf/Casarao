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
        setLabelConfig(number)
        
        let bet = SKLabelNode(text: String(gameRoom.bet))
        setLabelConfig(bet)
        
        let amount = SKLabelNode(text: String(gameRoom.amount))
        setLabelConfig(amount)
        
        let numPlayers = SKLabelNode(text: "\(gameRoom.players.count)/\(gameRoom.maxPlayers)")
        setLabelConfig(numPlayers)
        
        
        
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
    
    func setLabelConfig(label:SKLabelNode){
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        label.fontColor = SKColor.blackColor()
        label.zPosition = 4
        label.verticalAlignmentMode = .Center
    }
    
}