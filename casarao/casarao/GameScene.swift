//
//  GameScene.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    
    
    var matrix: MatrixNode!
    var chances : Int = 3{
        didSet{
            updateChancesLabel()
        }
    }
    var gameRoom:GameRoom!
    var player: Player!
    let chancesLabel = SKLabelNode(text:"Tentatias:")
    
    
    
    
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    
    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = 30 {
        willSet {
            if levelTimerValue == 0 {
                print("zerou")
            }
        }
        didSet {
            levelTimerLabel.text = "0:\(levelTimerValue)"
        }
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let background = SKSpriteNode(imageNamed: "black_background")
        background.size = self.size
        background.position = CGPoint(x: 0,y: 0)
        background.zPosition = 0
        self.addChild(background)
        
        
        
        matrix = MatrixNode(numColumns: 3, numRows: 3)
        matrix.position = CGPoint(x: 0,y: 0)
        self.addChild(matrix)
        
        
        
        let checkButton = SKSpriteNode(color: SKColor.cyanColor(), size: CGSize(width: 400, height: 100))
        checkButton.position = CGPoint(x:0,y:-500)
        checkButton.name = "checkButton"
        checkButton.zPosition = 1
        self.addChild(checkButton)
        
        
        setRoomInformation()
        
        
        
        
        
    }
    
    
    func setRoomInformation(){
        
        chancesLabel.text = "Tentatias:\(chances)"
        chancesLabel.position = CGPoint(x: 0, y: 600)
        chancesLabel.color = SKColor.whiteColor()
        chancesLabel.zPosition = 2
        self.addChild(chancesLabel)
        
    }
    
    func updateChancesLabel(){
        
        chancesLabel.text = "Tentatias:\(chances)"
        
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let node = self.nodeAtPoint(touch.locationInNode(self))
        
        if node is Tile{
            let tile = node as! Tile
            if tile.status != "right"{
                checkUserChances(tile)
            }
        }
        else if node.name == "checkButton"{
            checkUserMatrix()
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
        }
        else{
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.levelCountdown), userInfo: nil, repeats: true)
            loadWaitBGScreen()
            if results.tileRight.count != 0{
                for i in results.tileRight{
                    matrix.tilesArray[i].status = "right"
                }
            }
            chances = 3
        }
        
    }
//    
//    private func removeBlurBG() {
//        for child in self.children {
//            
//        }
//    }
    
    
    
    func levelCountdown() {
        levelTimerValue -= 1
        levelTimerLabel.text = String(levelTimerValue)
    }
    
    
    private func loadWaitBGScreen() {
        
        
        let popUpTimer = SKSpriteNode(texture: SKTexture(imageNamed: "grey_background"), color: SKColor.clearColor(), size: CGSize(width: 300, height: 300))
        
        popUpTimer.zPosition = 20
        levelTimerLabel.color  = SKColor.whiteColor()
        levelTimerLabel.position = CGPoint(x: 0,y: 0)
        levelTimerLabel.zPosition = 21
        popUpTimer.addChild(levelTimerLabel)
        popUpTimer.position = CGPoint(x: 0,y: 0)
        userInteractionEnabled = false
        
        levelTimerLabel.respondsToSelector(#selector(GameScene.levelCountdown))
        
        
        
        let duration = 0.5
        
        let waitBG:SKSpriteNode = self.getBluredScreenshot()
        
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
        let context = UIGraphicsGetCurrentContext()
        
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
        
        var scale:CGFloat = UIScreen.mainScreen().scale
        
        sprite.size.width  *= scale
        
        sprite.size.height *= scale
        
        return sprite
        
        
    }
    
}
