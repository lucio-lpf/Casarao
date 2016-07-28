//
//  endGamePopUp.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//


protocol PopUpInLobby {
    
    
    func didDeciedEnterRoom(response:Bool, selfpopUp:PopUpSpriteNode)
    
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
    var giveUpButton: SKSpriteNode? = nil
    

    
    
    init(bet: Double,scene: LobbyScene){
        super.init(texture: SKTexture(imageNamed: "Sprites") , color: SKColor.clearColor(), size: CGSize(width: 400, height: 600))
        userInteractionEnabled = true
        GameSceneDelegate = nil
        LobbySceneDelegate = scene
        joinButtonAccept = SKSpriteNode(texture: nil, color: SKColor.redColor(), size: CGSize(width: 200, height: 100))
        joinButtonAccept!.position = CGPoint(x: 0, y: -self.size.height/2)
        addChild(joinButtonAccept!)
        cancelJoinButton = SKSpriteNode(texture: nil, color: SKColor.blueColor(), size: CGSize(width: 200, height: 100))
        cancelJoinButton!.position = CGPoint(x: 0, y: self.size.height/2)
        addChild(cancelJoinButton!)
        

  

    }
    
    //POPUP COM LISTA DE USUARIOS DA SALA E SUAS PONTUAÇÕES
    init(users: Array<Player>,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
    }
    
    
    //POPUP DE DESITENCIA DA PARTIDA
    
    init(scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
    }
    
    
    //POPUP DO FIM DO JOGO COM O VENCEDOR
    init(winner: Player,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil

    }
    
    
    //POPUP COM  O TIME QUE É NECESSARIO ESPERAR PARA JOGAR NOVAMENTE
    init(timer:NSTimer,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "Sprite"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if joinButtonAccept != nil{
            if joinButtonAccept!.containsPoint(point){
                LobbySceneDelegate?.didDeciedEnterRoom(true,selfpopUp: self)
            }
            else if cancelJoinButton!.containsPoint(point){
                LobbySceneDelegate?.didDeciedEnterRoom(false,selfpopUp: self)
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