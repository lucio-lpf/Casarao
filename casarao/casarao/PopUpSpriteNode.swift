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
    
    func removeTimerFromScene(selfPopUp:PopUpSpriteNode)
}

import Foundation
import SpriteKit

class PopUpSpriteNode: SKSpriteNode {
    
    
    var GameSceneDelegate:PopUpInGame?
    var LobbySceneDelegate:PopUpInLobby?
    var joinButtonAccept: SKSpriteNode? = nil
    var cancelJoinButton: SKSpriteNode? = nil
    var closeScorePopUp: SKSpriteNode? = nil
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
    init(scorePerUser: Dictionary<String,Int> ,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "scorePopUp"), color: SKColor.clearColor(), size: CGSize(width: 300, height: 300))
        
        self.GameSceneDelegate = scene
        
        let myArr = Array(scorePerUser.keys)
        let sortedKeys = myArr.sort() {
            let obj1 = scorePerUser[$0] // get ob associated w/ key 1
            let obj2 = scorePerUser[$1] // get ob associated w/ key 2
            return obj1 > obj2
        }
        
        var yposition = self.size.height/2 - 50
        
        for key in sortedKeys{
            
            let player = scene.gameRoom.players.filter( { return $0.id == key } ).first
            
            let scoreLabel = SKLabelNode(text: "\(player!.nickname!) --- > \(scorePerUser[key]!)")
            scoreLabel.fontSize = 25
            scoreLabel.fontColor = SKColor.blackColor()
            scoreLabel.position = CGPoint(x: 0, y: yposition)
            scoreLabel.zPosition = self.zPosition + 1
            addChild(scoreLabel)
            yposition -= 35
            
        }
        self.LobbySceneDelegate = nil
        
        userInteractionEnabled = true
        
        closeScorePopUp = SKSpriteNode(texture:SKTexture(imageNamed: "x"), color: SKColor.clearColor(), size: CGSize(width: 40, height: 40))
        closeScorePopUp!.position = CGPoint(x: size.width/2, y: size.height/2)
        closeScorePopUp!.zPosition = zPosition + 1
        addChild(closeScorePopUp!)
        
    }
    
    
    //POPUP DE DESITENCIA DA PARTIDA
    
    init(scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "timerPopUp"), color: SKColor.clearColor(), size: CGSize(width: 300, height: 300))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
        
        let wait = SKAction.waitForDuration(10)
        let action = SKAction.runBlock {
            self.GameSceneDelegate!.removeTimerFromScene(self)
        }
        self.runAction(SKAction.sequence([wait,action]))
        
    }
    
    
    //POPUP DO FIM DO JOGO COM O VENCEDOR
    init(winner: String,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "loseMessenge"), color: SKColor.clearColor(), size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil

    }
    
    
    init(){
        
        super.init(texture: SKTexture(imageNamed: "youWonThePot"), color: SKColor.clearColor(), size: CGSize(width: 350, height: 350))

    }
    
    init(waitStartScene:GameScene){
        
        
        super.init(texture: SKTexture(imageNamed: "scorePopUp"), color: SKColor.clearColor(), size: CGSize(width: 350, height: 350))
        self.GameSceneDelegate = waitStartScene
        
        self.LobbySceneDelegate = nil
        
        
        userInteractionEnabled = true
        
        closeScorePopUp = SKSpriteNode(texture:SKTexture(imageNamed: "x"), color: SKColor.clearColor(), size: CGSize(width: 40, height: 40))
        closeScorePopUp!.position = CGPoint(x: size.width/2, y: size.height/2)
        closeScorePopUp!.zPosition = zPosition + 1
        addChild(closeScorePopUp!)
        
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
        
        if closeScorePopUp != nil{
            if closeScorePopUp!.containsPoint(point){
                GameSceneDelegate!.removeTimerFromScene(self)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}