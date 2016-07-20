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
    var matrix:Array2D<Tile>
    
    
    
    init(numColumns:Int,numRows:Int){
        matrix = Array2D<Tile>(columns: numColumns, rows: numRows)
        super.init(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 500, height: 500))
    
        //SO FUNCIONA PRA MATRIZES QUADRADAS
        
        for int in 0..<numColumns{
            matrix[int,0] = Tile()
            
            matrix[int,1] = Tile()
            matrix[int,2] = Tile()
        }
        
        addTilesAsMatrixChildren()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addTilesAsMatrixChildren(){
        
        //otimizar essa parte(muitos ifs)
        for column in 0..<matrix.columns{
            for row in 0..<matrix.rows{
                var x = 0
                var y = 0
                let tile = matrix[column,row]!
                if column == 2{
                    x = 200
                }
                if column == 0{
                    x = -200
                }
                if row == 2{
                    y = -200
                }
                if row == 0{
                    y = 200
                }
                
                tile.position = CGPoint(x: x, y: y)
                self.addChild(tile)
            }
        }
    }
    
    
    
    
    
}

struct Array2D<T> {
    let columns: Int
    let rows: Int
    private var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
