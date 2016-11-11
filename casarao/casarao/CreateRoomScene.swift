//
//  CreateRoomScene.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 26/10/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit



class CreateRoomScene: SKScene,UITextFieldDelegate{
    
    
    var player: Player?
    
    var userHUD:UserHUD!
    
    var exitButton:SKSpriteNode!
    
    var randomPass:Int!
    
    
    var passChoice:Bool = false{
        
        didSet{
            
            let node = childNode(withName: "passSwitch") as! SKSpriteNode
            if passChoice{
                node.texture = SKTexture(imageNamed:"yes_switch")
                let roomPassword = SKLabelNode(text: "Room's password: \(randomPass!)")
                roomPassword.name = "passText"
                roomPassword.position = CGPoint(x: 0, y: 0)
                setLabelConfig([roomPassword])
                
            }
            else{
                node.texture = SKTexture(imageNamed:"no_switch")
                if let text  = childNode(withName: "passText"){
                    text.removeFromParent()
                }
            }
            
        }
    
    }
    
    var numberOfPlayers:Int = 1{
        
        didSet{
            
            var node = childNode(withName: "passSwitch") as! SKLabelNode
            node = SKLabelNode(text: "\(numberOfPlayers)")
            print(node)

        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        
        userHUD = UserHUD(player: player!)
        userHUD.position = CGPoint(x: 0, y: size.height/2 - userHUD.size.height/2)
        userHUD.zPosition = 200
        addChild(userHUD)
        
        exitButton = SKSpriteNode(texture: SKTexture(imageNamed:"x"), color: .clear, size: SKTexture(imageNamed:"x").size())
        exitButton.position = CGPoint(x: -size.width/2 + exitButton.size.width/2 + 20, y: userHUD.position.y - userHUD.size.height/2 - exitButton.size.height/2 - 15)
        exitButton.zPosition = 200
        addChild(exitButton)
        
        addConfigurationsButtons()
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        if exitButton.contains(point){
            
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let scene:LobbyScene = LobbyScene(size: self.size)
            scene.player = player
            self.view?.presentScene(scene, transition: transition)
            print("quero sair daqui")
        }
            
        else if (childNode(withName: "passSwitch")?.contains(point))!{
            
            passChoice = !passChoice
            
            
        }
        
        else if (childNode(withName: "confirm")?.contains(point))!{
            creatRoom()
        }
        
        
        
    }
    
    func addConfigurationsButtons(){
        
        
        let roomName = SKLabelNode(text: "\(player!.nickname!)'s room")
        roomName.position = CGPoint(x: 0, y: exitButton.position.y - 40)
        
        randomPass = Int(arc4random_uniform(9000)) + 1000
        print(randomPass)
        
        
        
        let roomPassAsk = SKLabelNode(text: "This room will have passcode?")
        roomPassAsk.position = CGPoint(x: 0, y: roomName.position.y - 40)
        
        
        let passSwitch = SKSpriteNode(texture: SKTexture(imageNamed:"no_switch"), color: .clear, size: SKTexture(imageNamed:"no_switch").size())
        passSwitch.name = "passSwitch"
        passSwitch.position = CGPoint(x: 0, y: roomPassAsk.position.y - 40)
        addChild(passSwitch)
        
        
        let confirmButton = SKSpriteNode(texture: nil, color: .darkGray, size: CGSize(width: 300, height: 80))
        confirmButton.position = CGPoint(x: 0, y: -size.height/2 + confirmButton.size.height/2 + 30)
        confirmButton.name = "confirm"
        confirmButton.zPosition = 200
        addChild(confirmButton)
        
        
        
        
        setLabelConfig([roomName,roomPassAsk])
    }
    
    
    func setLabelConfig(_ labels:[SKLabelNode]){
        
        for label in labels{
            label.fontName = "AvenirNext-Bold"
            label.fontSize = 16
            label.fontColor = SKColor.white
            label.zPosition = 200
            label.verticalAlignmentMode = .center
            addChild(label)
        }
    }
    
    
    func creatRoom(){
        
        WebServiceManager.creatNewRoom((player?.id)!, roomId: "lala") { (bool) in
            print(bool)
        }
        
    }
}
