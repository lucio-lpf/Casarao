//
//  GameScene.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//

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
    var checkButton: SKSpriteNode
    var mountOfMoney: Int = 0{
        didSet{
            gameHUD.updateMountLabel(mountOfMoney)
        }
    }
    
    var gameHUD: GameHUD!
    
    // REFACTORING
    var stopInterval:NSTimer?
    
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    
    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = 5 {
        didSet {
            if levelTimerValue == 0 {
                removeBlurBG()
            }
            levelTimerLabel.text = "0:\(levelTimerValue)"
        }
    }
    
    init(size: CGSize,player: Player, gameRoom: GameRoom) {
        
        let background = SKSpriteNode(imageNamed: "black_background")
        
        checkButton = SKSpriteNode(texture: SKTexture(imageNamed: "checkButton") , color: SKColor.clearColor(), size: CGSize(width: 300, height: 70))

        
        self.gameRoom = gameRoom
        
        self.player = player
        
        
        super.init(size: size)
        
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        background.size = self.size
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        self.gameHUD = GameHUD(gameRoom: self.gameRoom, selfScene: self)
        
        gameHUD.position = CGPoint(x: 0, y: self.size.height/2 - gameHUD.size.height/2)
        self.addChild(gameHUD)
        
        matrix = MatrixNode(numColumns: 3, numRows: 3, scene: self)
        
        matrix.position = CGPoint(x: 0,y: 0)
        self.addChild(matrix)
        
        
        checkButton.position = CGPoint(x:0,y:-self.size.height/2 + checkButton.size.height)
        checkButton.name = "checkButton"
        checkButton.zPosition = 3
        addChild(checkButton)
        
        
        
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let point = touch.locationInNode(self)
        
        if checkButton.containsPoint(point){
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
    
    func checkUserMatrix() {
        
        gameRoom.parseObject.fetchInBackgroundWithBlock { (newobject, error) in
            self.gameRoom.parseObject = newobject!
            self.chackUserMatrix2()
        }
    }
    
    
    func chackUserMatrix2(){
        if gameRoom.status != "finished"{
            //atualizando a matriz do user
            player.currentMatrix?.removeAll()
            
            for tile in matrix.tilesArray{
                player.currentMatrix?.append(tile.colorNumber)
            }
            
            let results = player.checkUserAnswer()
            
            if results.didFinishTheGame{
                let popUpFinishGame = SKSpriteNode(texture: SKTexture(imageNamed: "grey_background"), color: SKColor.clearColor(), size: CGSize(width: 300, height: 300))
                let label = SKLabelNode(text: "Acabou o jogo!!!")
                popUpFinishGame.zPosition = 20
                label.color  = SKColor.whiteColor()
                label.position = CGPoint(x: 0,y: 0)
                label.zPosition = 21
                popUpFinishGame.addChild(label)
                popUpFinishGame.position = CGPoint(x: 0,y: 0)
                self.addChild(popUpFinishGame)
                userInteractionEnabled = false
                gameRoom.status = "finished"
                gameRoom.winner = player
            }
            else{
                stopInterval = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.levelCountdown), userInfo: nil, repeats: true)
                loadWaitBGScreen()
                if results.tileRight.count != 0{
                    for i in results.tileRight{
                        matrix.tilesArray[i].status = "right"
                    }
                }
                matrix.updateMatrixColors(player.currentMatrix!)
                chances = 3
            }
        }
        else{
            let pop = PopUpSpriteNode(winner: gameRoom.winner!, scene: self)
            pop.position = CGPoint(x: 0, y: 0)
            pop.zPosition = 50
            addChild(pop)
        }
        
    }
    
    // REFACTORING
    private func removeBlurBG() {
        let blurNode = self.childNodeWithName("blurBG")!
        let popUpTimer = self.childNodeWithName("popUpTimer")!
        
        var nodeToRemove:Array<SKNode> = Array()
        
        nodeToRemove.append(blurNode)
        nodeToRemove.append(popUpTimer)
        
        levelTimerLabel.hidden = true
        
        
        self.removeChildrenInArray(nodeToRemove)
        
        userInteractionEnabled = true
        
        stopInterval?.invalidate()
        
        levelTimerValue = 5
    }
    
    // REFACTORING
    func levelCountdown() {
        levelTimerValue -= 1
        levelTimerLabel.text = String(levelTimerValue)
    }
    
    
    // REFACTORING
    private func loadWaitBGScreen() {
        
        let popUpTimer = SKSpriteNode(texture: SKTexture(imageNamed: "grey_background"), color: SKColor.clearColor(), size: CGSize(width: 300, height: 300))
        
        popUpTimer.name = "popUpTimer"
        popUpTimer.zPosition = 20
        levelTimerLabel.color  = SKColor.whiteColor()
        levelTimerLabel.position = CGPoint(x: 0,y: 0)
        levelTimerLabel.zPosition = 21
        popUpTimer.addChild(levelTimerLabel)
        popUpTimer.position = CGPoint(x: 0,y: 0)
        userInteractionEnabled = false
        
        levelTimerLabel.respondsToSelector(#selector(GameScene.levelCountdown))
        
        levelTimerLabel.hidden = false
        
        
        
        let duration = 0.0
        
        let waitBG:SKSpriteNode = self.getBluredScreenshot()
        
        waitBG.name = "blurBG"
        
        //pauseBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        waitBG.alpha = 0
        waitBG.zPosition = self.zPosition + 1
        waitBG.runAction(SKAction.fadeAlphaTo(0.5, duration: duration))
        
        // add blur
        self.addChild(waitBG)
        
        // add timer over blur
        self.addChild(popUpTimer)
    }
    
    
    private func getBluredScreenshot() -> SKSpriteNode {
        
        //create the graphics context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view!.frame.size.width, height: self.view!.frame.size.height), true, 1)
        
        self.view!.drawViewHierarchyInRect(self.view!.frame, afterScreenUpdates: true)
        
        // retrieve graphics context
        _ = UIGraphicsGetCurrentContext()
        
        // query image from it
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // create Core Image context
        let ciContext = CIContext(options: nil)
        // create a CIImage, think of a CIImage as image data for processing, nothing is displayed or can be displayed at this point
        let coreImage = CIImage(image: image)
        // pick the filter we want
        let filter = CIFilter(name: "CIGaussianBlur")
        // pass our image as input
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        //edit the amount of blur
        filter!.setValue(10.0, forKey: kCIInputRadiusKey)
        
        //retrieve the processed image
        let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        // return a Quartz image from the Core Image context
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
        // final UIImage
        let filteredImage = UIImage(CGImage: filteredImageRef)
        
        // create a texture, pass the UIImage
        let texture = SKTexture(image: filteredImage)
        // wrap it inside a sprite node
        let sprite = SKSpriteNode(texture:texture)
        
        // make image the position in the center
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        let scale:CGFloat = UIScreen.mainScreen().scale
        
        sprite.size.width  *= scale
        
        sprite.size.height *= scale
        
        return sprite
        
        
    }
    
}
