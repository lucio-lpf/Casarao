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
    
    
    
    
    init(numColumns:Int,numRows:Int){
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: 400, height: 400))
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
    
    
    init(array:Array<Int>,answerArray:Array<Int>){
        
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: 400, height: 400))
        
        self.zPosition = 1
        //SO FUNCIONA PRA MATRIZES QUADRADAS
        
        for i in 0..<array.count{
            if array[i] == answerArray[i]{
                tilesArray.append(Tile(colorNumber: i,status: "right"))
            }
            else{
                tilesArray.append(Tile(colorNumber: i,status: "stillWrong"))
            }
            
        }
        
        addTilesAsMatrixChildren()
        
    }
    
    private func addTilesAsMatrixChildren() {
        //otimizar essa parte(muitos ifs)
        var countLine  = 0
        var y = +self.size.height/2
        var x = -self.size.width/2
        
        for i in 0..<tilesArray.count{
            let tile = tilesArray[i]
            tile.position = CGPoint(x: x, y: y)
            self.addChild(tile)
            countLine += 1
            x += self.size.width/2
            if countLine == 3{
                y -= self.size.height/2
                x = -self.size.width/2
                countLine = 0
            }
            
        }
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