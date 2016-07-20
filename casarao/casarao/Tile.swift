//
//  Tile.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import SpriteKit


class Tile: SKSpriteNode{
    
    
    
    init(){

        super.init(texture: nil, color: UIColor.redColor(), size: CGSize(width: 100, height: 100))
        
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
        changeColor()
    }
    
    
    func changeColor(){
        self.color = SKColor.blueColor()
        
    }
}