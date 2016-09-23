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
    
    
    var profileButton:SKSpriteNode
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loadingFrames = [SKTexture]()
    var loadedFrames = [SKTexture]()
    var loadSymbol = SKSpriteNode()
    
    var retangle = SKSpriteNode()
    
    var lastTimeUpdated = TimeInterval()
    
    
    var sectionButton = SKSpriteNode()
    
    
    // REFACTORING
    var player:Player!
    var selectedRoomNode:SKNode?
    
    var userHUD:UserHUD!
    
    
    
    
    override init(size: CGSize) {
        //SET TAB BUTTONS
        
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button"), color: SKColor.clear, size: CGSize(width: 110, height: 110 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button_disable"), color: SKColor.clear, size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //ADD TOP BAR
        
        let topBar = SKSpriteNode(texture: SKTexture(imageNamed: "lobbyTopBar"), color: SKColor.clear, size: SKTexture(imageNamed: "lobbyTopBar").size())
        topBar.position = CGPoint(x: 0, y: size.height/2 - topBar.size.height/2)
        addChild(topBar)
        
        //ADD TAB BUTTONS
        
        addChild(profileButton)
        
        addChild(lobbyButton)
        
        addChild(storeButton)
        
        
        WebServiceManager.returnGameRooms { (gameRooms) in
            
            self.gameRoomsSprites.removeAll()
            self.addRoomsToScene(gameRooms)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        lastTimeUpdated = CACurrentMediaTime()
        
        
        retangle = SKSpriteNode(texture: nil, color: SKColor.clear, size: CGSize(width: size.width, height: size.height - SKTexture(imageNamed: "lobbyTopBar").size().height - lobbyButton.size.height))
        retangle.zPosition += zPosition
        addChild(retangle)
        
        
        userHUD = UserHUD(player: player)
        userHUD.position = CGPoint(x: 0, y: size.height/2 - userHUD.size.height/2)
        userHUD.zPosition = 200
        addChild(userHUD)
        
        
        setAnimationFrames()
        // REFACTORING
        
        
    }
    
    
    func addRoomsToScene(_ gameRooms:[GameRoom]){
        
        if gameRooms.isEmpty{
            
        }
        else{
            var yposition = self.size.height/2 - 140
            for room in gameRooms{
                gameRoomsSprites.append(GameRoomSpriteNode(gameRoom: room, scene: self))
                gameRoomsSprites.last!.position = CGPoint(x: 0, y: yposition)
                gameRoomsSprites.last!.zPosition = 3
                yposition -= 80
                
                addChild(gameRoomsSprites.last!)
                
            }
        }
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
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
                print("time for update nigga")
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
            
            reloadGameRooms()
            
        }
            
        else{
            for gameRoomsSprite in gameRoomsSprites{
                if gameRoomsSprite.contains(point){
                    let alphaNode = SKSpriteNode(color: UIColor.black, size: self.size)
                    alphaNode.alpha = 0.0
                    alphaNode.name = "alphaNode"
                    alphaNode.isUserInteractionEnabled = true
                    alphaNode.zPosition = 53
                    self.addChild(alphaNode)
                    alphaNode.run(SKAction.fadeAlpha(to: 0.5, duration: 0.25))
                    gameRoomsSprite.alertSprite = nil
                    joinGame(gameRoomsSprite.gameRoom)
                }
            }
        }
    }
    
    
    
    
    func reloadGameRooms(){
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
        let scene:SKScene = GameScene(size: self.size, player: self.player, gameRoom: gameRoom)
        
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
    
    
    
}



















