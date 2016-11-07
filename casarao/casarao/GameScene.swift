//
//  GameScene.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//


/* Z POSITIONS
 
 
 
 
 
 */
import SpriteKit
import UserNotifications

class GameScene: SKScene, PopUpInGame,GameHUDProtocol{
    
    
    var matrix: MatrixNode!
    var chances : Int = 3{
        didSet{
            gameHUD.updateChancesLabel(chances)
        }
    }
    var userHUD:UserHUD!
    
    var gameRoom:GameRoom
    var player: Player
    var loadingFrames = [SKTexture]()
    let defaults = UserDefaults.standard

    var loadedFrames = [SKTexture]()
    var loadSymbol = SKSpriteNode()
    var checkButton: SKSpriteNode!
    var timerController = TimeInterval()
    
    var mountOfMoney: Int = 0{
        didSet{
            gameHUD.updateMountLabel(mountOfMoney)
        }
    }
    
    var  tutorialController:Int!
    var gameHUD: GameHUD!
    
    
    //Immediately after leveTimerValue variable is set, update label's text
    
    init(size: CGSize,player: Player, gameRoom: GameRoom) {
        
        
        

        
        self.gameRoom = gameRoom
        
        self.player = player
        
        
        super.init(size: size)
        
        
        
        
        
        
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        addAlphaNode()
        
        setAnimationFrames()
        
        animateLoading()
        
        
        checkButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clear, size: SKTexture(imageNamed: "checkButton").size())

        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "black_background")
        
        background.size = self.size
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        
        userHUD.position = CGPoint(x: 0, y: self.size.height/2 - userHUD.size.height/2)
        addChild(userHUD)
        
        self.gameHUD = GameHUD(gameRoom: self.gameRoom, selfScene: self)
        
        gameHUD.position = CGPoint(x: 0, y: userHUD.position.y - userHUD.size.height/2 - gameHUD.size.height/2)
        self.addChild(gameHUD)
        
        matrix = MatrixNode(gameRoom: gameRoom, playerId: player.id)
        
        matrix.position = CGPoint(x: 0,y: 0)
        self.addChild(matrix)
        
        
        checkButton.position = CGPoint(x:0,y:-self.size.height/2 + checkButton.size.height)
        checkButton.name = "checkButton"
        checkButton.zPosition = 5
        addChild(checkButton)
        
        
        let buttonBackground = SKSpriteNode(texture: nil, color: UIColor.init(red: 235, green: 237, blue: 237, alpha: 1), size: CGSize(width: size.width, height: (checkButton.position.y + size.height/2)*2))
        buttonBackground.position = checkButton.position
        buttonBackground.zPosition = 4
        addChild(buttonBackground)
        
        let checkLabel = SKLabelNode(text: "Check!")
        checkLabel.fontName =  "HelveticaNeue"
        checkLabel.position = CGPoint(x: 0, y: -6)
        checkLabel.fontSize = 20
        checkLabel.zPosition = checkButton.zPosition + 2
        checkButton.addChild(checkLabel)

        
        WebServiceManager.checkUserPlayTimer(player.id, roomId: gameRoom.id) { (bool,time) in
            
            if !bool{
                
                self.waitTimePopUp(time!)
            }
            else{
                self.removeLoadingAnimation()
            }
            
        }
        
        
        if tutorialController != nil{
            
            
            nextTutorial()
            
        }
        
        
 
    }
    
    func nextTutorial(){
        
        defaults.set(true, forKey: "tutorial")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if currentTime - timerController > 1{
            if let timerPopUp = childNode(withName: "TimerPopUp") as? PopUpSpriteNode{
                timerPopUp.updateTImer()
            }
            
            timerController = currentTime
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first!
        let point = touch.location(in: self)
        
        if checkButton.contains(point){
            addAlphaNode()
            checkUserMatrix()
            return
        }
        if matrix.contains(point){
            for tile in matrix.tilesArray{
                if tile.contains(point){
                    
                    checkUserChances(tile)
                    return
                }
            }
        }
        
        if gameHUD.contains(point){
            
           
        }
    }
    
    
    func userGaveUpGame(_ response: Bool, selfpopUp: PopUpSpriteNode) {
        if response{
            
            
            //remover player da sala
            
        }
        else{
            selfpopUp.removeFromParent()
        }
    }
    
    func checkUserChances(_ tile:Tile) {
        if tile.status == "Wrong"{
            if tile.colorNumber == 3 {
                self.chances += 1
                tile.changeColor()
                return
            }
            if tile.colorNumber != 0{
                tile.changeColor()
                return
            }
            if chances > 0{
                if tile.colorNumber == 0{
                    self.chances -= 1
                    tile.changeColor()
                }
            }
        }
        
    }
    
    func checkUserMatrix() {
        

            WebServiceManager.checkUserMatrix(player.id, roomId: gameRoom.id, playerMatrixArray: matrix.playerMatrixArray()) { (playerArray, winner,newObject) in
                
                if (playerArray != nil) && (winner == nil){
                    
                    
                    
                    self.gameRoom.parseObject = newObject!
                    self.matrix.changeMatrixToNewMatrix(playerArray!)
                    let timerPopUp = PopUpSpriteNode(scene: self, seconds: self.gameRoom.timer)
                    self.chances = 3
                    timerPopUp.zPosition = 200
                    
                   /* if let index = AlertSpriteKit.gameRoomsToPlay.index(of: self.gameRoom.id) {
                        AlertSpriteKit.gameRoomsToPlay.remove(at: index)
                    }*/
                    
                    
                    if #available(iOS 10.0, *) {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Hey You!!!"
                    content.body = "It's time to play again! Don't waist any time."
                    content.sound = UNNotificationSound.default()
                    content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
                    
                    
                    
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(self.gameRoom.timer), repeats: false)
                   
                    
                    let request = UNNotificationRequest(identifier: "PlayAgain", content: content, trigger: trigger)
                        
                        
                    let center = UNUserNotificationCenter.current()
                        
                    center.add(request, withCompletionHandler: { (error) in
                        guard let _ = error else{
                            
                            print("Notificação adicionada com sucesso")
                            
                            return
                        }
                        print(error?.localizedDescription ?? 10)
                    })
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                self.addChild(timerPopUp)
                    
                    
                    
                }
                else if (playerArray != nil) && (winner != nil){

                    let congratulations = PopUpSpriteNode()
                    congratulations.zPosition = 200
                    self.addChild(congratulations)
                    self.userHUD.incrementCoins(value: self.gameRoom.amount)
                    
                }
                else if (playerArray == nil) && (winner == nil){
                    
                    let waitRoomStart = PopUpSpriteNode(waitStartScene: self)
                    waitRoomStart.position = CGPoint(x: 0, y: 0)
                    waitRoomStart.zPosition = 200
                    self.addChild(waitRoomStart)
                    
                }
                else{
                    let losePopUp = PopUpSpriteNode(winner: winner!,scene: self)
                    losePopUp.position = CGPoint(x: 0, y: 0)
                    losePopUp.zPosition = 200
                    self.addChild(losePopUp)
                }
                
                
                
        }
        
    }
    
    
    //MARK: Protocol Funcs
    
    func backToLobby(){
        
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:LobbyScene = LobbyScene(size: self.size)
        scene.player = player
        self.view?.presentScene(scene, transition: transition)
        
        
    }
    
    func removeTimerFromScene(_ selfPopUp: PopUpSpriteNode) {
        
        selfPopUp.removeFromParent()
        removeAction(forKey: "loading")
        self.childNode(withName: "rectangle")?.removeFromParent()
        self.childNode(withName: "alphaNode")?.removeFromParent()
    }
    
    func otherUserScore(){
        
        addAlphaNode()
        
        animateLoading()
        
//        WebServiceManager.roomScoreTable(gameRoom.id) { (Dict) in
//            
//            let scorePopUp = PopUpSpriteNode(scorePerUser: Dict!, scene: self)
//            scorePopUp.position = CGPoint(x: 0,y: 0)
//            scorePopUp.zPosition = 200
//            self.addChild(scorePopUp)
//            
//        }
        
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
    
    func removeLoadingAnimation(){
        
        self.loadSymbol.removeFromParent()
        self.childNode(withName: "rectangle")?.removeFromParent()
        self.childNode(withName: "alphaNode")?.removeFromParent()
    }
    
    
    func addAlphaNode(){
        
        let alphaNode = SKSpriteNode(color: UIColor.black, size: self.size)
        alphaNode.alpha = 0.0
        alphaNode.name = "alphaNode"
        alphaNode.zPosition = 150
        alphaNode.isUserInteractionEnabled = true
        self.addChild(alphaNode)
        alphaNode.run(SKAction.fadeAlpha(to: 0.8, duration: 0.15))
    }
    
    
    func waitTimePopUp(_ seconds:Int){
        
        
        removeLoadingAnimation()
        addAlphaNode()
        let timerPopUp = PopUpSpriteNode(scene: self, seconds: seconds)
        timerPopUp.zPosition = 200
        self.addChild(timerPopUp)
        
    }
}
