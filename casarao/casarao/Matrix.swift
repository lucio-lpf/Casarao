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
        
        super.init(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 400, height: 400))
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
}