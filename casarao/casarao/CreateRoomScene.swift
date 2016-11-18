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
    
    var playersCount:Int
    
    var playersPlus:SKSpriteNode!
    
    var playersLess: SKSpriteNode!
    
    var betPlus: SKSpriteNode!
    
    var betLess: SKSpriteNode!
    
    var roomBet = 50
    
    var roomTime = 5
    
    var timePlus: SKSpriteNode!
    
    var timeLess: SKSpriteNode!
    
    var passChoice:Bool = false{
        
        didSet{
            
            let node = childNode(withName: "passSwitch") as! SKSpriteNode
            if passChoice{
                node.texture = SKTexture(imageNamed:"yes_switch")
                let roomPassword = SKLabelNode(text: "Room's password: \(randomPass!)")
                roomPassword.name = "passText"
                roomPassword.fontSize = 10
                roomPassword.horizontalAlignmentMode = .left
                roomPassword.position = CGPoint(x: -size.width/2 + 10, y: childNode(withName: "roomPassAsk")!.position.y - 25)
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
        
        playersCount = 2
        
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
        else if (playersPlus!.contains(point)){
            
            playersCount += 1
            updateLabel(named: "playersCountLabel")
            
        }
        else if playersLess.contains(point){
            
            playersCount -= 1
            updateLabel(named: "playersCountLabel")


        }
        else if betPlus.contains(point){
            
            roomBet += 50
            updateLabel(named: "betCountLabel")
            
        }
        else if betLess.contains(point){
            
            roomBet -= 50
            updateLabel(named: "betCountLabel")
            
            
        }
        
        else if timePlus.contains(point){
            
            roomTime += 5
            updateLabel(named: "timeCountLabel")
            
        }
        else if timeLess.contains(point){
            
            roomTime -= 5
            updateLabel(named: "timeCountLabel")
            
            
        }
        
        
    }
    
    func addConfigurationsButtons(){
        
        
        let roomName = SKLabelNode(text: "\(player!.nickname!)'s room")
        roomName.position = CGPoint(x: 0, y: exitButton.position.y)
        
        randomPass = Int(arc4random_uniform(9000)) + 1000
        print(randomPass)
        
        
        
        let roomPassAsk = SKLabelNode(text: "This room will have passcode?")
        roomPassAsk.name = "roomPassAsk"
        roomPassAsk.position = CGPoint(x: -size.width/2 + 10, y: roomName.position.y - 75)
        roomPassAsk.horizontalAlignmentMode = .left
        
        let passSwitch = SKSpriteNode(texture: SKTexture(imageNamed:"no_switch"), color: .clear, size: SKTexture(imageNamed:"no_switch").size())
        passSwitch.name = "passSwitch"
        passSwitch.position = CGPoint(x: size.width/2 - passSwitch.size.width/2 - 20, y: roomPassAsk.position.y)
        addChild(passSwitch)
        
        
        //---------------------------------------
        
        let playersLabel = SKLabelNode(text: "Number of Players:")
        playersLabel.name = "playersLabel"
        playersLabel.position = CGPoint(x: -size.width/2 + 10, y: roomPassAsk.position.y - 75)
        playersLabel.horizontalAlignmentMode = .left
        
        
        let playersCountLabel = SKLabelNode(text: "\(playersCount)" )
        playersCountLabel.name = "playersCountLabel"
        playersCountLabel.position = CGPoint(x: size.width/4, y: playersLabel.position.y)
        playersCountLabel.horizontalAlignmentMode = .left
        
        

        playersPlus = SKSpriteNode(texture: SKTexture(imageNamed:"plus"), color: .clear, size: SKTexture(imageNamed:"plus").size())
        playersPlus.position = CGPoint(x: size.width/4 + 35, y: playersLabel.position.y)
        addChild(playersPlus)
        
        playersLess = SKSpriteNode(texture: SKTexture(imageNamed:"less"), color: .clear, size: SKTexture(imageNamed:"less").size())
        playersLess.position = CGPoint(x: size.width/4 - 35, y: playersLabel.position.y)
        addChild(playersLess)
        
        
        //--------------------------------------
        
        
        let betLabel = SKLabelNode(text: "Buy In:")
        betLabel.name = "betLabel"
        betLabel.position = CGPoint(x: -size.width/2 + 10, y: playersLabel.position.y - 75)
        betLabel.horizontalAlignmentMode = .left
        
        
        let betCountLabel = SKLabelNode(text: "\(roomBet)" )
        betCountLabel.name = "betCountLabel"
        betCountLabel.position = CGPoint(x: size.width/4 - 5, y: betLabel.position.y)
        betCountLabel.horizontalAlignmentMode = .left
        
        
        
        betPlus = SKSpriteNode(texture: SKTexture(imageNamed:"plus"), color: .clear, size: SKTexture(imageNamed:"plus").size())
        betPlus.position = CGPoint(x: size.width/4 + 35, y: betLabel.position.y)
        addChild(betPlus)
        
        betLess = SKSpriteNode(texture: SKTexture(imageNamed:"less"), color: .clear, size: SKTexture(imageNamed:"less").size())
        betLess.position = CGPoint(x: size.width/4 - 35, y: betLabel.position.y)
        addChild(betLess)
        
        //----------------------------------------
        
        
        
        let timeLabel = SKLabelNode(text: "Time between plays:")
        timeLabel.name = "timeLabel"
        timeLabel.position = CGPoint(x: -size.width/2 + 10, y: betLabel.position.y - 75)
        timeLabel.horizontalAlignmentMode = .left
        
        
        let timeCountLabel = SKLabelNode(text: "\(roomTime)" )
        timeCountLabel.name = "timeCountLabel"
        timeCountLabel.position = CGPoint(x: size.width/4, y: timeLabel.position.y)
        timeCountLabel.horizontalAlignmentMode = .left
        
        
        
        timePlus = SKSpriteNode(texture: SKTexture(imageNamed:"plus"), color: .clear, size: SKTexture(imageNamed:"plus").size())
        timePlus.position = CGPoint(x: size.width/4 + 35, y: timeLabel.position.y)
        addChild(timePlus)
        
        timeLess = SKSpriteNode(texture: SKTexture(imageNamed:"less"), color: .clear, size: SKTexture(imageNamed:"less").size())
        timeLess.position = CGPoint(x: size.width/4 - 35, y: timeLabel.position.y)
        addChild(timeLess)
        
        //----------------------------------------
        
        let  checkButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clear, size: SKTexture(imageNamed: "checkButton").size())
        checkButton.position = CGPoint(x:0,y:-self.size.height/2 + checkButton.size.height)
        checkButton.name  = "confirm"
        checkButton.zPosition = 5
        addChild(checkButton)
        
        
        let buttonBackground = SKSpriteNode(texture: nil, color: UIColor.init(red: 235, green: 237, blue: 237, alpha: 1), size: CGSize(width: size.width, height: (checkButton.position.y + size.height/2)*2))
        buttonBackground.position = checkButton.position
        buttonBackground.zPosition = 4
        addChild(buttonBackground)
        
        let checkLabel = SKLabelNode(text: "Create!")
        checkLabel.fontName =  "HelveticaNeue"
        checkLabel.position = CGPoint(x: 0, y: -6)
        checkLabel.fontSize = 20
        checkLabel.zPosition = checkButton.zPosition + 2
        checkButton.addChild(checkLabel)
        
        setLabelConfig([roomName,roomPassAsk,playersLabel,playersCountLabel, betLabel, betCountLabel,timeLabel,timeCountLabel])
    }
    
    
    func setLabelConfig(_ labels:[SKLabelNode]){
        
        for label in labels{
            label.fontName = "Helvetica Neue"
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
    
    func updateLabel(named:String){
     
       var label = childNode(withName: named) as? SKLabelNode
        label?.removeFromParent()
        guard label != nil else {
            return
        }
        switch named {
        case "playersCountLabel":
            
            label = SKLabelNode(text: "\(playersCount)")
            label?.position = CGPoint(x: playersPlus.position.x - 35, y: playersPlus.position.y)
            label?.name = "playersCountLabel"
            break
            
        case "betCountLabel":
            
            label = SKLabelNode(text: "\(roomBet)")
            label?.position = CGPoint(x: betPlus.position.x - 35, y: betPlus.position.y)
            label?.name = "betCountLabel"
            break
            
        case "timeCountLabel":
            
            label = SKLabelNode(text: "\(roomTime)")
            label?.position = CGPoint(x: timePlus.position.x - 35, y: timePlus.position.y)
            label?.name = "timeCountLabel"
            break
            
        default:
            break
        }
       
        setLabelConfig([label!])
    }
}
