//
//  Matrix.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import SpriteKit


class MatrixNode : SKSpriteNode {
    //TODO: LUCIO ARRAY 2D\
    
    var tilesArray = Array<Tile>()
    var numberOfColumns:Int!
    
    
    
    
    init(numColumns:Int,numRows:Int,scene:SKScene){
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: scene.size.width - 100, height: scene.size.height/4))
        self.zPosition = 1
        //SO FUNCIONA PRA MATRIZES QUADRADAS
        let numberOfTiles = numRows*numColumns
        
        for _ in 0..<numberOfTiles{
            tilesArray.append(Tile())
        }
        
        addTilesAsMatrixChildren()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(gameRoom:GameRoom,playerId:String){
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: 400, height: 400))
        
        self.zPosition = 1
        //SO FUNCIONA PRA MATRIZES QUADRADAS
        
        gameRoom.parseObject.fetchInBackgroundWithBlock { (newObject, error) in
            let userArray = gameRoom.playerMatrix[playerId]
            for int in userArray!{
                if int == 0{
                    self.tilesArray.append(Tile(colorNumber: int, status: "Wrong"))
                }
                else{
                    self.tilesArray.append(Tile(colorNumber: int, status: "Right"))
                }
                
            }
            self.addTilesAsMatrixChildren()
        }
        
        
    }
    
    private func addTilesAsMatrixChildren() {
        //otimizar essa parte(muitos ifs)
        var countLine  = 0
        var y = +self.size.height/4
        var x = -self.size.width/4
        for i in 0..<tilesArray.count{
            let tile = tilesArray[i]
            tile.position = CGPoint(x: x, y: y)
            self.addChild(tile)
            countLine += 1
            x += self.size.width/4
            if countLine == 3{
                y -= self.size.height/4
                x = -self.size.width/4
                countLine = 0
            }
            
        }
    }
    
    func changeMatrixToNewMatrix(newArray: Array<Int>){
    
        for i in 0..<tilesArray.count{
            if newArray[i] != 0{
                tilesArray[i].colorNumber = newArray[i]
                tilesArray[i].status = "Right"
            }
            else{
                tilesArray[i].colorNumber = 0
                tilesArray[i].status = "Wrong"
            }
        }
        
    }
    
    func playerMatrixArray()->(Array<Int>){
        
        var array = Array<Int>()
        
        for tile in tilesArray{
            array.append(tile.colorNumber)
        }
        return array
    }
    
    
    func updateMatrixColors(currentPlayerMatrix:Array<Int>){
        
        for i in 0..<tilesArray.count{
            if currentPlayerMatrix[i] == 0{
                tilesArray[i].colorNumber = 0
                tilesArray[i].texture = SKTexture(imageNamed: "white_tile")
            }
        }
        
    }
}