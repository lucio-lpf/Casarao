//
//  endGamePopUp.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//


protocol PopUpInLobby {
    
    
    func didDeciedEnterRoom(_ response:Bool, selfpopUp:PopUpSpriteNode,gameRoom:GameRoom?)
    
}

protocol PopUpInGame {
    func userGaveUpGame(_ response:Bool, selfpopUp:PopUpSpriteNode)
    
    func removeTimerFromScene(_ selfPopUp:PopUpSpriteNode)
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
    var timer:SKLabelNode!
    var timePlusWaitTime = TimeInterval()
    var giveUpButton: SKSpriteNode? = nil
    

    
    
    init(gameRoom: GameRoom,scene: LobbyScene){
        self.gameRoom = gameRoom
        super.init(texture: SKTexture(imageNamed: "LobbyPopUp") , color: SKColor.clear, size: SKTexture(imageNamed: "LobbyPopUp").size())
        isUserInteractionEnabled = true
        zPosition =  1005
        GameSceneDelegate = nil
        LobbySceneDelegate = scene
        joinButtonAccept = SKSpriteNode(texture: SKTexture(imageNamed:"yesButton"), color: SKColor.clear, size: SKTexture(imageNamed:"yesButton").size())
        joinButtonAccept!.position = CGPoint(x: size.width/4, y: -self.size.height/3.5)
        joinButtonAccept?.zPosition = 5
        addChild(joinButtonAccept!)
        cancelJoinButton = SKSpriteNode(texture: SKTexture(imageNamed:"noButton"), color: SKColor.clear, size: SKTexture(imageNamed:"noButton").size())
        cancelJoinButton!.position = CGPoint(x: -size.width/4, y: -self.size.height/3.5)
        cancelJoinButton?.zPosition = 5
        addChild(cancelJoinButton!)
        

  

    }
    
    
    init(tutorialNumber:Int){
        
        
        var newTexture: SKTexture
        newTexture = SKTexture(imageNamed: "tutorialPopUp\(tutorialNumber)")
        super.init(texture: newTexture, color: SKColor.clear, size: newTexture.size())

        
    }
    
    //POPUP COM LISTA DE USUARIOS DA SALA E SUAS PONTUAÇÕES
    init(scorePerUser: Dictionary<String,Int> ,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "scorePopUp"), color: SKColor.clear, size: CGSize(width: 300, height: 300))
        
        self.GameSceneDelegate = scene
        
//        let myArr = Array(scorePerUser.keys)
//        let sortedKeys = myArr.sort() {
//            let obj1 = scorePerUser[$0] // get ob associated w/ key 1
//            let obj2 = scorePerUser[$1] // get ob associated w/ key 2
//            return obj1 > obj2
//        }
//        
//        var yposition = self.size.height/2 - 50
//        
//        for key in sortedKeys{
//            
//            let player = scene.gameRoom.players.filter( { return $0  == key } ).first
//            
//            let scoreLabel = SKLabelNode(text: "\(player!.nickname!) --- > \(scorePerUser[key]!)")
//            scoreLabel.fontSize = 25
//            scoreLabel.fontColor = SKColor.blackColor()
//            scoreLabel.position = CGPoint(x: 0, y: yposition)
//            scoreLabel.zPosition = self.zPosition + 1
//            addChild(scoreLabel)
//            yposition -= 35
//            
//        }
        self.LobbySceneDelegate = nil
        
        isUserInteractionEnabled = true
        
        closeScorePopUp = SKSpriteNode(texture:SKTexture(imageNamed: "x"), color: SKColor.clear, size: CGSize(width: 40, height: 40))
        closeScorePopUp!.position = CGPoint(x: size.width/2, y: size.height/2)
        closeScorePopUp!.zPosition = zPosition + 1
        addChild(closeScorePopUp!)
        
    }
    
    
    //POPUP DE DESITENCIA DA PARTIDA
    
    init(scene: GameScene, seconds:Int){
        super.init(texture: SKTexture(imageNamed: "timerPopUp"), color: SKColor.clear, size: CGSize(width: 300, height: 300))

        timePlusWaitTime = NSDate().timeIntervalSince1970 + Double(seconds)
        
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil
        
        name = "TimerPopUp"
        
        updateTImer()
        
        
        
    }
    
    func updateTImer(){
        
        childNode(withName: "timer")?.removeFromParent()
        
        
        let timeNow  = NSDate().timeIntervalSince1970
        
        
        let timeToPlay = timePlusWaitTime - timeNow
        if timeToPlay > 0{
            
            timer = SKLabelNode(text: timeToPlay.minuteSecond)
            timer.name = "timer"
            
        }else{
            timer = SKLabelNode(text: "00:00")
            self.GameSceneDelegate!.removeTimerFromScene(self)
        }
        
        timer.position = CGPoint(x: 0, y: -size.height/4)
        setLabel(label: timer)
        
        
        
    }
    
    func setLabel(label:SKLabelNode){
        
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        label.fontColor = SKColor.black
        label.zPosition = 4
        label.verticalAlignmentMode = .center
        addChild(label)
        
    }
    
    //POPUP DO FIM DO JOGO COM O VENCEDOR
    init(winner: String,scene: GameScene){
        super.init(texture: SKTexture(imageNamed: "loseMessenge"), color: SKColor.clear, size: CGSize(width: 200, height: 400))
        self.GameSceneDelegate = scene
        self.LobbySceneDelegate = nil

    }
    
    
    init(){
        
        super.init(texture: SKTexture(imageNamed: "youWonThePot"), color: SKColor.clear, size: CGSize(width: 350, height: 350))

    }
    
    init(waitStartScene:GameScene){
        
        
        super.init(texture: SKTexture(imageNamed: "scorePopUp"), color: SKColor.clear, size: CGSize(width: 350, height: 350))
        self.GameSceneDelegate = waitStartScene
        
        self.LobbySceneDelegate = nil
        
        
        isUserInteractionEnabled = true
        
        closeScorePopUp = SKSpriteNode(texture:SKTexture(imageNamed: "x"), color: SKColor.clear, size: CGSize(width: 40, height: 40))
        closeScorePopUp!.position = CGPoint(x: size.width/2, y: size.height/2)
        closeScorePopUp!.zPosition = zPosition + 1
        addChild(closeScorePopUp!)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        
        
        
        if joinButtonAccept != nil{
            if joinButtonAccept!.contains(point){
                LobbySceneDelegate?.didDeciedEnterRoom(true,selfpopUp: self,gameRoom: self.gameRoom)
            }
            else if cancelJoinButton!.contains(point){
                LobbySceneDelegate?.didDeciedEnterRoom(false,selfpopUp: self,gameRoom: nil)
            }
        }
        if giveUpButton != nil{
            if giveUpButton!.contains(point){
                
            }
        }
        
        if closeScorePopUp != nil{
            if closeScorePopUp!.contains(point){
                GameSceneDelegate!.removeTimerFromScene(self)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
