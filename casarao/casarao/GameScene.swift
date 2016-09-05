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
class GameScene: SKScene, PopUpInGame,GameHUDProtocol{
    
    
    var matrix: MatrixNode!
    var chances : Int = 3{
        didSet{
            gameHUD.updateChancesLabel(chances)
        }
    }
    var gameRoom:GameRoom
    var player: Player
    var loadingFrames = [SKTexture]()
    var loadedFrames = [SKTexture]()
    var loadSymbol = SKSpriteNode()
    var checkButton: SKSpriteNode!
    var mountOfMoney: Int = 0{
        didSet{
            gameHUD.updateMountLabel(mountOfMoney)
        }
    }
    
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
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        addAlphaNode()
        
        setAnimationFrames()
        
        animateLoading()
        
        checkButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clearColor(), size: CGSize(width: 300, height: 70))

        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "black_background")
        
        background.size = self.size
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        self.gameHUD = GameHUD(gameRoom: self.gameRoom, selfScene: self)
        
        gameHUD.position = CGPoint(x: 0, y: self.size.height/2 - gameHUD.size.height/2)
        self.addChild(gameHUD)
        
        matrix = MatrixNode(gameRoom: gameRoom, playerId: player.id)
        
        matrix.position = CGPoint(x: 0,y: 0)
        self.addChild(matrix)
        
        
        checkButton.position = CGPoint(x:0,y:-self.size.height/2 + checkButton.size.height)
        checkButton.name = "checkButton"
        checkButton.zPosition = 3
        addChild(checkButton)
        
        WebServiceManager.checkUserPlayTimer(player.id, roomId: gameRoom.id) { (bool,time) in
            
            if !bool{
                
                self.waitTimePopUp(time!)
            }
            else{
                self.removeLoadingAnimation()
            }
            
        }
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if checkButton.containsPoint(point){
            addAlphaNode()
            checkUserMatrix()
            return
        }
        if matrix.containsPoint(point){
            for tile in matrix.tilesArray{
                if tile.containsPoint(point){
                    
                    checkUserChances(tile)
                    return
                }
            }
        }
        
        if gameHUD.containsPoint(point){
            
           
        }
    }
    
    
    func userGaveUpGame(response: Bool, selfpopUp: PopUpSpriteNode) {
        if response{
            
            
            //remover player da sala
            
        }
        else{
            selfpopUp.removeFromParent()
        }
    }
    
    func checkUserChances(tile:Tile) {
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
        

            WebServiceManager.checkUserMatrix(player.id, roomId: gameRoom.id, playerMatrixArray: matrix.playerMatrixArray()) { (playerArray, winner) in
                print(playerArray,winner)
                
                if (playerArray != nil) && (winner == nil){
                    
                    
                    
                    
                    self.matrix.changeMatrixToNewMatrix(playerArray!)
                    let timerPopUp = PopUpSpriteNode(scene: self, seconds: self.gameRoom.timer)
                    self.chances = 3
                    timerPopUp.zPosition = 200
                    self.addChild(timerPopUp)
                }
                else if (playerArray != nil) && (winner != nil){

                    let congratulations = PopUpSpriteNode()
                    congratulations.zPosition = 200
                    self.addChild(congratulations)
                    
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
        
        let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
        let scene:LobbyScene = LobbyScene(size: self.size)
        scene.player = player
        self.view?.presentScene(scene, transition: transition)
        
        
    }
    
    func removeTimerFromScene(selfPopUp: PopUpSpriteNode) {
        
        selfPopUp.removeFromParent()
        actionForKey("loading")?.finalize()
        self.childNodeWithName("rectangle")?.removeFromParent()
        self.childNodeWithName("alphaNode")?.removeFromParent()
    }
    
    func otherUserScore(){
        
        addAlphaNode()
        
        animateLoading()
        
        WebServiceManager.roomScoreTable(gameRoom.id) { (Dict) in
            
            let scorePopUp = PopUpSpriteNode(scorePerUser: Dict!, scene: self)
            scorePopUp.position = CGPoint(x: 0,y: 0)
            scorePopUp.zPosition = 200
            self.addChild(scorePopUp)
            
        }
        
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
    
    func removeLoadingAnimation(){
        
        self.loadSymbol.removeFromParent()
        self.childNodeWithName("rectangle")?.removeFromParent()
        self.childNodeWithName("alphaNode")?.removeFromParent()
    }
    
    
    func addAlphaNode(){
        
        let alphaNode = SKSpriteNode(color: UIColor.blackColor(), size: self.size)
        alphaNode.alpha = 0.0
        alphaNode.name = "alphaNode"
        alphaNode.zPosition = 150
        alphaNode.userInteractionEnabled = true
        self.addChild(alphaNode)
        alphaNode.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.25))
    }
    
    
    func waitTimePopUp(seconds:Int){
        
        
        removeLoadingAnimation()
        addAlphaNode()
        let timerPopUp = PopUpSpriteNode(scene: self, seconds: seconds)
        timerPopUp.zPosition = 200
        self.addChild(timerPopUp)
        
    }
}
