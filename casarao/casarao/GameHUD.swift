//
//  RoomInformationNode.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//


protocol GameHUDProtocol{
    
}

import Foundation
import SpriteKit


class GameHUD: SKSpriteNode{
    
    
    var gameSceneDelegate: GameHUDProtocol
    
    var amountOfMoneyLabel = SKLabelNode(text:"Total de cash:")
    
    
    let giveUpButton = SKSpriteNode(texture: nil, color: SKColor.clearColor(), size: CGSize(width: 50, height: 50))
    
    var chancesLabel = SKLabelNode(text:"Tentatias:")
    
    let backToLobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButton"), color: SKColor.whiteColor(), size: CGSize(width: 100, height: 65))
    
    
    let otherUsersScoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "playerIcon"), color: SKColor.clearColor(), size: CGSize(width: 50, height: 40))
    
    
    init(gameRoom: GameRoom, selfScene: GameScene) {
        
        gameSceneDelegate = selfScene
        
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: selfScene.size.width, height: selfScene.size.height/4))
        //LABEL DAS CHANCES DO USUARIO
        zPosition = 2
        
        userInteractionEnabled = true
        
        chancesLabel.text = "Chances: \(selfScene.chances)"
        chancesLabel.fontName = "AvenirNext-Bold"
        chancesLabel.fontSize = 16

        chancesLabel.position = CGPoint(x: 0, y: -self.size.height/4)
        chancesLabel.color = SKColor.whiteColor()
        chancesLabel.zPosition = 3
        self.addChild(chancesLabel)
        
        
        // QUANTIDADE DE DINHEIRO TOTAL DA SALA
        
        amountOfMoneyLabel.text = "Amount of Coins: \(gameRoom.amount)"
        amountOfMoneyLabel.fontName = "AvenirNext-Bold"
        amountOfMoneyLabel.fontSize = 16
        amountOfMoneyLabel.position = CGPoint(x: 0, y: 0)
        amountOfMoneyLabel.color = SKColor.whiteColor()
        amountOfMoneyLabel.zPosition = 3
        self.addChild(amountOfMoneyLabel)
        
        
        //BOTAO DE DESISTIR DO JOGO
        
        
        giveUpButton.position = CGPoint(x: -self.size.width/2 + 40, y: self.size.height/2)
        giveUpButton.zPosition = 100
        addChild(giveUpButton)
        
        
        otherUsersScoreButton.position = CGPoint(x: +self.size.width/2 - otherUsersScoreButton.size.width, y: self.size.height/2 - otherUsersScoreButton.size.height/2 - 20)
        otherUsersScoreButton.zPosition = 100
        addChild(otherUsersScoreButton)
        
        
        backToLobbyButton.position = CGPoint(x: -self.size.width/2 + backToLobbyButton.size.width/2, y: self.size.height/2 - backToLobbyButton.size.height/2 - 20)
        backToLobbyButton.zPosition = 100
        addChild(backToLobbyButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateMountLabel(mount : Int){
        
        amountOfMoneyLabel.text = "Total de cash:\(mount)"
        
    }
    
    func updateChancesLabel(chances: Int){
        
        chancesLabel.text = "Tentatias:\(chances)"
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if giveUpButton.containsPoint(point){
            
        }
        else if otherUsersScoreButton.containsPoint(point){
            
        }
            
        else if backToLobbyButton.containsPoint(point){
            
        }
        
    }
}