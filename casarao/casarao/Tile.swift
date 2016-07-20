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
    
    init(){
        
        super.init(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 100, height: 100))
        self.colorNumber = -1
        self.userInteractionEnabled = true
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture,color:color, size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        
        colorNumber = colorNumber + 1
        changeColor()
        
        
    }
    
    
    func changeColor(){
        
        switch self.colorNumber {
            
        case 0:
            self.color = SKColor.redColor()
            
        case 1:
            self.color = SKColor.blueColor()
            
        case 2:
            self.color = SKColor.greenColor()
            
        default:
            self.colorNumber = 0
            changeColor()
        }
    }
}