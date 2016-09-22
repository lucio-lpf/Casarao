//
//  RoomInformationNode.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//


protocol GameHUDProtocol{
    
    func backToLobby()
    
    func otherUserScore()
    
}

import Foundation
import SpriteKit


class GameHUD: SKSpriteNode{
    
    
    var gameSceneDelegate: GameHUDProtocol
    
    var amountOfMoneyLabel = SKLabelNode(text:"Total de cash:")
    
    
    let giveUpButton = SKSpriteNode(texture: SKTexture(imageNamed: "x"), color: SKColor.clear, size: SKTexture(imageNamed: "x").size())
    
    var chancesLabel = SKLabelNode(text:"Chances:")
    
    let backToLobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButton"), color: SKColor.white, size: SKTexture(imageNamed: "backButton").size())
    
    
    let otherUsersScoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "scoreIcon"), color: SKColor.clear, size:  SKTexture(imageNamed: "scoreIcon").size())
    
    
    init(gameRoom: GameRoom, selfScene: GameScene) {
        
        gameSceneDelegate = selfScene
        
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: selfScene.size.width, height: selfScene.size.height/4))
        //LABEL DAS CHANCES DO USUARIO
        zPosition = 2
        
        isUserInteractionEnabled = true
        
        chancesLabel.text = "Chances: \(selfScene.chances)"
        chancesLabel.fontName = "aspace"
        chancesLabel.fontSize = 16

        chancesLabel.position = CGPoint(x: 0, y: -self.size.height/2)
        chancesLabel.color = SKColor.white
        chancesLabel.zPosition = 3
        self.addChild(chancesLabel)
        
        
        // QUANTIDADE DE DINHEIRO TOTAL DA SALA
        
        amountOfMoneyLabel.text = "Amount of Coins: \(gameRoom.amount)"
        amountOfMoneyLabel.fontName = "aspace"
        amountOfMoneyLabel.fontSize = 16
        amountOfMoneyLabel.position = CGPoint(x: 0, y: -size.height/4)
        amountOfMoneyLabel.color = SKColor.white
        amountOfMoneyLabel.zPosition = 3
        self.addChild(amountOfMoneyLabel)
        
        
        //BOTAO DE DESISTIR DO JOGO
        
        
        giveUpButton.position = CGPoint(x: self.size.width/2 - giveUpButton.size.width, y: self.size.height/2 - 50)
        giveUpButton.zPosition = 200
        addChild(giveUpButton)
        
        
        otherUsersScoreButton.position = CGPoint(x: 0, y: self.size.height/2 - 50)
        otherUsersScoreButton.zPosition = 200
        addChild(otherUsersScoreButton)
        
        
        backToLobbyButton.position = CGPoint(x: -self.size.width/2 + backToLobbyButton.size.width, y: self.size.height/2 - 50)
        backToLobbyButton.zPosition = 250
        addChild(backToLobbyButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateMountLabel(_ mount : Int){
        
        amountOfMoneyLabel.text = "Total de cash:\(mount)"
        
    }
    
    func updateChancesLabel(_ chances: Int){
        
        chancesLabel.text = "Tentatias:\(chances)"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        if giveUpButton.contains(point){
            
        }
        else if otherUsersScoreButton.contains(point){
            gameSceneDelegate.otherUserScore()
        }
            
        else if backToLobbyButton.contains(point){
            
            gameSceneDelegate.backToLobby()
        }
        
    }
}
