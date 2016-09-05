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
    
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    var profileButton:SKSpriteNode
    var lobbyButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var loadingFrames = [SKTexture]()
    var loadedFrames = [SKTexture]()
    var loadSymbol = SKSpriteNode()
    
    
    // REFACTORING
    var player:Player!
    var selectedRoomNode:SKNode?
    
    var userHUD:UserHUD!
    
    
    
    
    override init(size: CGSize) {
        //SET TAB BUTTONS
        
        
        profileButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_profile_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        profileButton.position = CGPoint(x: -size.width/2 + profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        lobbyButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_lobby_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        lobbyButton.position = CGPoint(x: 0, y: -size.height/2 + profileButton.size.height/2)
        
        storeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home_store_button"), color: SKColor.clearColor(), size: CGSize(width: 100, height: 100 ))
        storeButton.position = CGPoint(x: size.width/2 - profileButton.size.width/2, y: -size.height/2 + profileButton.size.height/2)
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        //ADD TOP BAR
        
        let topBar = SKSpriteNode(texture: SKTexture(imageNamed: "lobbyTopBar"), color: SKColor.clearColor(), size: SKTexture(imageNamed: "lobbyTopBar").size())
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
    
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        userHUD = UserHUD(player: player)
        userHUD.position = CGPoint(x: 0, y: size.height/2 - userHUD.size.height/2)
        userHUD.zPosition = 200
        addChild(userHUD)
        
        
        setAnimationFrames()
        // REFACTORING
        
        
    }
    
    
    func addRoomsToScene(gameRooms:[GameRoom]){
        
        if gameRooms.isEmpty{
            
        }
        else{
            var yposition = self.size.height/2 - 120
            for room in gameRooms{
                gameRoomsSprites.append(GameRoomSpriteNode(gameRoom: room, scene: self))
                gameRoomsSprites.last!.position = CGPoint(x: 0, y: yposition)
                gameRoomsSprites.last!.zPosition = 3
                yposition -= 80
                addChild(gameRoomsSprites.last!)
                
            }
        }
        
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if profileButton.containsPoint(point){
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:ProfileScene = ProfileScene(size: self.size)
            scene.player = player
            removeFromParent()
            self.view?.presentScene(scene, transition: transition)
            
        }
        else if storeButton.containsPoint(point){
            
            let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
            let scene:SKScene = StoreScene(size: self.size)
            removeFromParent()
            self.view?.presentScene(scene, transition: transition)
            
        }
        else if lobbyButton.containsPoint(point){
            
            reloadGameRooms()
            
        }
            
        else{
            for gameRoomsSprite in gameRoomsSprites{
                if gameRoomsSprite.containsPoint(point){
                    let alphaNode = SKSpriteNode(color: UIColor.blackColor(), size: self.size)
                    alphaNode.alpha = 0.0
                    alphaNode.name = "alphaNode"
                    alphaNode.userInteractionEnabled = true
                    alphaNode.zPosition = 53
                    self.addChild(alphaNode)
                    alphaNode.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.25))
                    joinGame(gameRoomsSprite.gameRoom)
                }
            }
        }
    }
    
    
    
    
    func reloadGameRooms(){
    }
    
    func joinGame(gameRoom: GameRoom) {
        
        animateLoading()
        
        WebServiceManager.checkIfUserIsInRoom(player.id, roomId: gameRoom.id) { (bool) in
            if bool{
                
                self.moveToGameRoom(gameRoom)
                
            }
            else{
                //    ALPHA NODE
                
                
                
                
                self.addChild(PopUpSpriteNode(gameRoom: gameRoom, scene: self))
                
            }
        }
        
        
        
    }
    
    func moveToGameRoom(gameRoom:GameRoom){
        
        let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
        let scene:SKScene = GameScene(size: self.size, player: self.player, gameRoom: gameRoom)
        
        self.removeFromParent()
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    override func removeFromParent() {
        
        removeAllActions()
        removeAllChildren()
        super.removeFromParent()
    }
    
    
    
 
    
    func didDeciedEnterRoom(response: Bool,selfpopUp:PopUpSpriteNode,gameRoom:GameRoom?) {
        if response {
            
            WebServiceManager.addUserToRoom(player.id, roomId: gameRoom!.id) { (bool) in
                print(bool)
                if bool{
                    let localCoins = self.defaults.integerForKey("coins")
                    self.defaults.setInteger(localCoins - (gameRoom?.bet)!, forKey: "coins")
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
        self.childNodeWithName("rectangle")?.removeFromParent()
        self.childNodeWithName("alphaNode")?.removeFromParent()
        selfpopUp.removeFromParent()
    }
    
    
    func animateLoading() {
        //cria a ação
        let loadingAction = SKAction.animateWithTextures(loadingFrames, timePerFrame: 0.03)
        
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
        loadSymbol.runAction((SKAction.repeatActionForever(loadingAction)), withKey: "loading")
    }
    
    
    private func transitioToScene(scene:SKScene) {
        
        let transition = SKTransition.crossFadeWithDuration(0.5)
        // Configure the view.
        let skView = self.view!
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
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



















