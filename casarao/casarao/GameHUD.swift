//
//  RoomInformationNode.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 25/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit


class GameHUD: SKSpriteNode{
    
    
    var amountOfMoneyLabel = SKLabelNode(text:"Total de cash:")
    
    
    let giveUpButton = SKSpriteNode(texture: nil, color: SKColor.blueColor(), size: CGSize(width: 50, height: 50))
    
    var chancesLabel = SKLabelNode(text:"Tentatias:")
    
    let backToLobbyButton = SKSpriteNode(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 100, height: 50))
    
    
    let otherUsersScoreButton = SKSpriteNode(texture: nil, color: SKColor.redColor(), size: CGSize(width: 50, height: 50))
    
    
    init(gameRoom: GameRoom, selfScene: GameScene) {
        
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: selfScene.size.width, height: selfScene.size.height/4))
        //LABEL DAS CHANCES DO USUARIO
        
        
        chancesLabel.text = "Tentatias:\(selfScene.chances)"
        chancesLabel.fontName = "AvenirNext-Bold"
        chancesLabel.position = CGPoint(x: 0, y: 0)
        chancesLabel.color = SKColor.whiteColor()
        chancesLabel.zPosition = 2
        self.addChild(chancesLabel)
        
        
        // QUANTIDADE DE DINHEIRO TOTAL DA SALA
        
        amountOfMoneyLabel.text = "Total de cash:\(gameRoom.amount)"
        amountOfMoneyLabel.fontName = "AvenirNext-Bold"
        amountOfMoneyLabel.position = CGPoint(x: 0, y: self.size.height/2)
        amountOfMoneyLabel.color = SKColor.whiteColor()
        amountOfMoneyLabel.zPosition = 2
        self.addChild(amountOfMoneyLabel)
        
        
        //BOTAO DE DESISTIR DO JOGO
        
        
        giveUpButton.position = CGPoint(x: -self.size.width/2 + 40, y: self.size.height/2)
        giveUpButton.zPosition = 3
        addChild(giveUpButton)
        
        
        otherUsersScoreButton.position = CGPoint(x: +self.size.width/2 - 40, y: self.size.height/2)
        otherUsersScoreButton.zPosition = 3
        addChild(otherUsersScoreButton)
        
        
        backToLobbyButton.position = CGPoint(x: -self.size.width/2 + 40, y: self.size.height - 50)
        backToLobbyButton.zPosition = 3
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
    
}