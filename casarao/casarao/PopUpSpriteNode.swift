//
//  endGamePopUp.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//


protocol PopUpInLobby {
    
    
    func didDeciedEnterRoom(response:Bool, selfpopUp:PopUpSpriteNode,gameRoom:GameRoom?)
    
}

protocol PopUpInGame {
    func userGaveUpGame(response:Bool, selfpopUp:PopUpSpriteNode)
}

import Foundation
import SpriteKit

class PopUpSpriteNode: SKSpriteNode{
    
    
    var GameSceneDelegate:PopUpInGame?
    var LobbySceneDelegate:PopUpInLobby?
    var joinButtonAccept: SKSpriteNode? = nil
    var cancelJoinButton: SKSpriteNode? = nil
    var gameRoom:GameRoom?
    var giveUpButton: SKSpriteNode? = nil
    

    
    
    init(gameRoom: GameRoom,scene: LobbyScene){
        self.gameRoom = gameRoom
        super.init(texture: SKTexture(imageNamed: "LobbyPopUp") , color: SKColor.clearColor(), size: SKTexture(imageNamed: "LobbyPopUp").size())
        userInteractionEnabled = true
        zPosition =  1000
        GameSceneDelegate = nil
        LobbySceneDelegate = scene
        joinButtonAccept = SKSpriteNode(texture: SKTexture(imageNamed:"yesButton"), color: SKColor.clearColor(), size: CGSize(width: 150, height: 100))
        joinButtonAccept!.position = CGPoint(x: 0, y: -self.size.height/4)
        joinButtonAccept?.zPosition = 5
        addChild(joinButtonAccept!)
        cancelJoinButton = SKSpriteNode(texture: SKTexture(imageNamed:"x"), color: SKColor.clearColor(), size: CGSize(width: 50, height: 50))
        cancelJoinButton!.position = CGPoint(x: self.size.width/2 - 50, y: self.size.height/2)
        cancelJoinButton?.zPosition = 5
        addChild(cancelJoinButton!)
        

  

    }
    
    //POPUP COM LISTA DE USUARIOS DA SALA E SUAS PONTUAÇÕES
    init(users: Array<Player>,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
        
        
        
        var firstPlayer = users[0]
        
        for player in users{
            
            if player.numberOfUserRightAnswers() > firstPlayer.numberOfUserRightAnswers(){
                firstPlayer = player
            }
        }
    }
    
    
    //POPUP DE DESITENCIA DA PARTIDA
    
    init(scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "giveUpPopUp"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
    }
    
    
    //POPUP DO FIM DO JOGO COM O VENCEDOR
    init(winner: Player,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "loseMessenge"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil

    }
    
    
    //POPUP COM  O TIME QUE É NECESSARIO ESPERAR PARA JOGAR NOVAMENTE
    init(timer:NSTimer,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprites"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
    }
    
    
    init(){
        
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if joinButtonAccept != nil{
            if joinButtonAccept!.containsPoint(point){
                LobbySceneDelegate?.didDeciedEnterRoom(true,selfpopUp: self,gameRoom: self.gameRoom)
            }
            else if cancelJoinButton!.containsPoint(point){
                LobbySceneDelegate?.didDeciedEnterRoom(false,selfpopUp: self,gameRoom: nil)
            }
        }
        if giveUpButton != nil{
            if giveUpButton!.containsPoint(point){
                
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}