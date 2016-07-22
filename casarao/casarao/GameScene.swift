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
        
        
        
        let checkButton = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 400, height: 100))
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
    
    
    func checkUserChances(tile:Tile){
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
            if results.tileRight.count != 0{
                for i in results.tileRight{
                    matrix.tilesArray[i].status = "right"
                }
            }
            matrix.updateMatrixColors(player.currentMatrix!)
            chances = 3
        }
        
    }
    
}
