//
//  LobbyScene.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/20/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit
import Parse

class LobbyScene: SKScene, PopUpInLobby {
    
    var gameRoomsSprites:Array<GameRoomSpriteNode> = Array()
    
    
    let defaults = UserDefaults.standard
    
    var tutorialController = 0
    
    var profileButton:SKSpriteNode
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loadingFrames = [SKTexture]()
    var loadedFrames = [SKTexture]()
    var loadSymbol = SKSpriteNode()
    
    var retangle = SKSpriteNode()
    
    var sectionButton:SKSpriteNode!
    
    var adNewRoomButton: SKSpriteNode!

    
    var lastTimeUpdated = TimeInterval()
    
    var lastTimeTimersUpdated = TimeInterval()
    
    
    var filterController:SKSpriteNode!
    var filterType = "None"
    
    
    // REFACTORING
    var player:Player!
    
    var selectedRoomNode:SKNode?
    
    var roomType = "public"
    
    
    
    var userHUD:UserHUD!
    
    
    
    
    override init(size: CGSize) {
        //SET TAB BUTTONS
        
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button"), color: SKColor.clear, size: CGSize(width: 120, height: 120 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    
        //ADD TAB BUTTONS
        
        addChild(profileButton)
        
        addChild(lobbyButton)
        
        addChild(storeButton)
        
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        lastTimeUpdated = CACurrentMediaTime()
        
        
        retangle = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: size.width, height: size.height/1.5))
        retangle.position = CGPoint(x: 0, y: 0)
        addChild(retangle)
        
        
        
        userHUD = UserHUD(player: player)
        userHUD.position = CGPoint(x: 0, y: size.height/2 - userHUD.size.height/2)
        userHUD.zPosition = 200
        addChild(userHUD)
        
        
        filterController = SKSpriteNode(texture: SKTexture(imageNamed:"filterBar"), color: UIColor.clear, size: CGSize(width: size.width - 20, height: 30))
        filterController.position = CGPoint(x: 0, y: userHUD.position.y - userHUD.size.height - 20)
        addChild(filterController)
        
        WebServiceManager.returnGameRooms(filterType,roomType: roomType){ (gameRooms) in
            
            self.gameRoomsSprites.removeAll()
            self.addRoomsToScene(gameRooms)
            
        }
        setAnimationFrames()
        // REFACTORING
        
        
        if (defaults.value(forKey: "tutorial") as! Bool != true){
            
            addAlpha()
            
            nextTutorial(point: CGPoint(x: 0, y: 0))
        }
        
        print(defaults.value(forKey: "tutorial") ?? 10)
        
        
        //SECTIONBUTTON
        
        sectionButton = SKSpriteNode(texture: SKTexture(imageNamed:"lobby_section_public"), color: .clear, size: SKTexture(imageNamed:"lobby_section_public").size())
        sectionButton.position = CGPoint(x: 0, y: lobbyButton.position.y + 10 + lobbyButton.size.height/2)
        sectionButton.zPosition = 90
        addChild(sectionButton)
        
        
    }
    
    
    
    func nextTutorial(point:CGPoint){
        
        self.childNode(withName: "tutorialPopUp")?.removeFromParent()
        
        let popup = PopUpSpriteNode(tutorialNumber:tutorialController)
        popup.name = "tutorialPopUp"
        popup.position = CGPoint(x:0,y:0)
        popup.zPosition = 1001
        addChild(popup)
        
        print(tutorialController)
        switch(tutorialController){
            
        case 0,4:
            tutorialController += 1

            break
            
        case 1:
            
            profileButton.zPosition = 1002
            if profileButton.contains(point){
                let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                let scene:ProfileScene = ProfileScene(size: self.size)
                scene.player = player
                scene.tutorialController = tutorialController + 1
                removeFromParent()
                self.view?.presentScene(scene, transition: transition)
            }
            break
            
            
        case 5:
            gameRoomsSprites[0].zPosition = 1002
            if gameRoomsSprites[0].contains(point){
                joinGame(gameRoomsSprites[0].gameRoom)
            }
            
        default:
            break
            
            
        }
        
    }
    func addRoomsToScene(_ gameRooms:[GameRoom]){
        
        
        
        
        if gameRooms.isEmpty{
            
        }
        else{
            var yposition = filterController.position.y - 60
            for room in gameRooms{
                gameRoomsSprites.append(GameRoomSpriteNode(gameRoom: room, scene: self))
                gameRoomsSprites.last!.position = CGPoint(x: 0, y: yposition)
                gameRoomsSprites.last!.zPosition = 3
                yposition -= 60
                
                addChild(gameRoomsSprites.last!)
                
            }
        }
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
 
        
        if currentTime - lastTimeTimersUpdated > 1{
            
            for sprite in gameRoomsSprites{
                sprite.updateTimerLabel()
                lastTimeTimersUpdated = currentTime
            }
        }
        
            if currentTime - lastTimeUpdated > 5{
                
                updateSpritesInScene()
                
                
                lastTimeUpdated = currentTime
                
                WebServiceManager.updateUserRooms(player.id, callBack: { (array) in
                    
                    
                    for object in array{
                        
                        for sprite in self.gameRoomsSprites{
                            
                            if sprite.gameRoom.id == object.id{
                                
                                sprite.updateGameRoom(object,playerId: self.player.id)
                            }
                        }
                    }
                    
                    
                })
            }
        
    }
    
    func updateSpritesInScene(){
        
        for sprite in gameRoomsSprites{
            
            if retangle.intersects(sprite){
                sprite.fetchGameRoom(self.player.id)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        
        if defaults.value(forKey: "tutorial") as! Bool != true{
            
            nextTutorial(point: point)
            return
        }
        
        
        
        
        if profileButton.contains(point){
            
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let scene:ProfileScene = ProfileScene(size: self.size)
            scene.player = player
            removeFromParent()
            self.view?.presentScene(scene, transition: transition)
            
        }
        else if storeButton.contains(point){
            
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let scene:StoreScene = StoreScene(size: self.size)
            scene.player = player
            
            removeFromParent()
            self.view?.presentScene(scene, transition: transition)
            
        }
        else if lobbyButton.contains(point){
            
            reloadGameRooms(type: roomType)
            
        }
        
        else if filterController.contains(point){
            

            
            if point.x < -filterController.size.width/4{
                
                filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar_Bet"))
                if filterType != "bet"{
                    filterType = "bet"
                }
                else{
                    filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar"))

                    filterType = "None"
                }
                reloadGameRooms(type:roomType)
                
            }
            else if point.x > filterController.size.width/4 {
                filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar_Players"))
                if filterType != "Players"{
                    filterType = "Players"
                }
                else{
                    filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar"))
                    filterType = "None"
                }
                
                
            }
            else if point.x <= 0 {
                
                filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar_TimeLeft"))
                if filterType != "timeLeft"{
                    filterType = "timeLeft"
                }
                else{
                    filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar"))
                    filterType = "None"
                }
                
            }
            else{
                
               filterController.texture = SKTexture(image:  #imageLiteral(resourceName: "filterBar_Pot"))
                if filterType != "amount"{
                    filterType = "amount"
                }
                else{
                    filterController.texture = SKTexture(image: #imageLiteral(resourceName: "filterBar"))
                    filterType = "None"
                }
                reloadGameRooms(type:roomType)
            }
            
           // reloadGameRooms()
            
        }
            
        else if sectionButton.contains(point){
            
            
            if point.x > 0{

                setRooms(type: "private")
            }
            else{
                setRooms(type: "public")
                print("public rooms")
            }
            print("secton button")
        }
            
         if roomType == "private"{
            if adNewRoomButton.contains(point){
                let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                let scene:CreateRoomScene = CreateRoomScene(size: self.size)
                scene.player = player
                removeFromParent()
                self.view?.presentScene(scene, transition: transition)
            }
        }
        else{
            for gameRoomsSprite in gameRoomsSprites{
                if gameRoomsSprite.contains(point){
                    addAlpha()
                    gameRoomsSprite.alertSprite = nil
                    joinGame(gameRoomsSprite.gameRoom)
                }
            }
        }
    }
    
    
    func setRooms(type:String){
        
        
        
        if roomType != type{
            
            print("mudou")
            roomType = type
            sectionButton.texture = SKTexture(imageNamed:"lobby_section_\(type)")
            
            reloadGameRooms(type:roomType)

            
            if roomType == "private"{
                
                adNewRoomButton = SKSpriteNode(texture: SKTexture(imageNamed:"creat_new_room_button"), color: .clear, size: SKTexture(imageNamed:"creat_new_room_button").size())
                adNewRoomButton.zPosition = 1000
                adNewRoomButton.position = CGPoint(x: 0, y: 0)
                addChild(adNewRoomButton)
            }
            else{
                adNewRoomButton?.removeFromParent()
            }
            
        }
    }
    
    
    
    func addAlpha(){
        let alphaNode = SKSpriteNode(color: UIColor.black, size: self.size)
        alphaNode.alpha = 0.0
        alphaNode.name = "alphaNode"
        alphaNode.isUserInteractionEnabled = true
        alphaNode.zPosition = 100
        self.addChild(alphaNode)
        alphaNode.run(SKAction.fadeAlpha(to: 0.8, duration: 0.15))
    }
    
    func reloadGameRooms(type:String){
        
        addAlpha()
        animateLoading()
        
        WebServiceManager.returnGameRooms(filterType,roomType: roomType){ (gameRooms) in
            
            self.gameRoomsSprites.forEach({ (gameRoom) in
                gameRoom.removeFromParent()
            })
            self.gameRoomsSprites.removeAll()
            self.addRoomsToScene(gameRooms)
            self.removeLoadingAnimation()
            
        }
        
       
        
    }
    
    func joinGame(_ gameRoom: GameRoom) {
        
        animateLoading()
        
        WebServiceManager.checkIfUserIsInRoom(player.id, roomId: gameRoom.id) { (bool) in
            if bool{
                self.moveToGameRoom(gameRoom)
            }
            else{
                self.addChild(PopUpSpriteNode(gameRoom: gameRoom, scene: self))
                
            }
        }
    }
    
    func moveToGameRoom(_ gameRoom:GameRoom){
        
        
       
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:GameScene = GameScene(size: self.size, player: self.player, gameRoom: gameRoom)
        scene.userHUD = userHUD
        if (defaults.value(forKey: "tutorial") as! Bool != true){
            scene.tutorialController = tutorialController + 1
        }
        self.removeFromParent()
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    override func removeFromParent() {
        
        removeAllActions()
        removeAllChildren()
        super.removeFromParent()
    }
    
    
    
    
    
    func didDeciedEnterRoom(_ response: Bool,selfpopUp:PopUpSpriteNode,gameRoom:GameRoom?) {
        if response {
            
            WebServiceManager.addUserToRoom(player.id, roomId: gameRoom!.id) { (bool) in
                print(bool)
                if bool{
                    let localCoins = self.defaults.integer(forKey: "coins")
                    self.defaults.set(localCoins - (gameRoom?.bet)!, forKey: "coins")
                    self.userHUD.updateCoinsLabel()
                    self.moveToGameRoom(gameRoom!)
                    
                }
                else{
                    
                    
                }
            }
            
        }
            
        else{
            
            print("User dosen't have enough money ")
        }
        
        self.loadSymbol.removeFromParent()
        self.childNode(withName: "rectangle")?.removeFromParent()
        self.childNode(withName: "alphaNode")?.removeFromParent()
        selfpopUp.removeFromParent()
    }
    
    
    func animateLoading() {
        //cria a ação
        let loadingAction = SKAction.animate(with: loadingFrames, timePerFrame: 0.03)
        
        //cria a "pop up"
        let rectangle = SKSpriteNode(texture: SKTexture(imageNamed: "loadTwitter"))
        rectangle.zPosition = 54
        rectangle.size = CGSize(width: 100, height: 100)
        rectangle.name = "rectangle"
        self.addChild(rectangle)
        
        //cria o nodo onde vai ter animação
        self.loadSymbol = SKSpriteNode(texture: SKTexture(imageNamed: ""))
        self.loadSymbol.zPosition = 55
        self.loadSymbol.size = CGSize(width: 50, height: 50)
        rectangle.addChild(self.loadSymbol)
        
        //executa a ação
        loadSymbol.run((SKAction.repeatForever(loadingAction)), withKey: "loading")
    }
    
    
    fileprivate func transitioToScene(_ scene:SKScene) {
        
        let transition = SKTransition.crossFade(withDuration: 0.5)
        // Configure the view.
        let skView = self.view!
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene, transition: transition)
        
    }
    
    
    func setAnimationFrames() {
        //seta os frames do top
        for i in 0 ... 19{
            let textureName = "loading\(i)"
            self.loadingFrames.append(SKTexture(imageNamed: textureName))
        }
        
        for i in 0 ... 10{
            let textureName = "loaded\(i)"
            self.loadedFrames.append(SKTexture(imageNamed: textureName))
        }
    }
    
    
    func removeLoadingAnimation(){
        
        self.loadSymbol.removeFromParent()
        self.childNode(withName: "rectangle")?.removeFromParent()
        self.childNode(withName: "alphaNode")?.removeFromParent()
    }
    
    
    
}



















