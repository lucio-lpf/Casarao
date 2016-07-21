//
//  Tile.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode{

    
    var colorNumber:Int!
    var status:String!
    
    init(){
        super.init(texture:SKTexture(imageNamed: "white_tile.png"), color: SKColor.clearColor(), size: CGSize(width: 127, height: 122))
        colorNumber = 0
        self.zPosition = 2
        status = "stillWrong"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture,color:color, size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func changeColor() {
        
        colorNumber = colorNumber + 1

        switch self.colorNumber {
        case 0:
            self.texture = SKTexture(imageNamed: "white_tile.png")
            
        case 1:
            self.texture = SKTexture(imageNamed: "orange_tile.png")
            
        case 2:
            self.texture = SKTexture(imageNamed: "blue_tile.png")
            
        case 3:
            self.texture = SKTexture(imageNamed: "pink_tile.png")
            
        default:
            self.colorNumber = 0
            self.texture = SKTexture(imageNamed: "white_tile.png")
        }
    }
}