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
    
    var alertSprite: SKSpriteNode!
    
    init(gameRoom:GameRoom,scene:LobbyScene){
        
        self.gameRoom = gameRoom
        super.init(texture: SKTexture(imageNamed:"gameRoomCell"), color: SKColor.clear, size: CGSize(width: scene.size.width - 20, height: 50))
        
        setLabels()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelConfig(_ label:SKLabelNode){
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        label.fontColor = SKColor.black
        label.zPosition = 4
        label.verticalAlignmentMode = .center
    }
    
    func updateGameRoom(_ object:GameRoom,playerId:String){
        
        self.gameRoom = object
        
        removeAllChildren()
        
        
         
        setLabels()
        
        if alertSprite == nil{
        
            if let lastPlay = gameRoom.timeOfLastUserPlay(playerId){
                
                if lastPlay > Double(gameRoom.timer){
                    setAlert()
                }
                
            }
        }
        else{
            setAlert()
        }
        
    }
    
    func setAlert(){
        
        alertSprite = SKSpriteNode(texture: SKTexture(imageNamed:"alert"), color: SKColor.clear, size: SKTexture(imageNamed:"alert").size())
        alertSprite.position = CGPoint(x: self.size.width/2 - alertSprite.size.width/4, y: self.size.height/2 - alertSprite.size.height/4)
        alertSprite.zPosition += zPosition
        addChild(alertSprite)
        
    }
    
    
    func setLabels(){
        
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
    
    func fetchGameRoom(_ playerId:String){
        
        gameRoom.parseObject.fetchInBackground { (newObject, error) in
            if let _ = error{
                print(error.debugDescription)
            }
            else{
                let newGameRoom = GameRoom(pfobject: newObject!)
                self.updateGameRoom(newGameRoom, playerId: playerId)
            }
        }
    }
}
