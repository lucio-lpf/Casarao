//
//  GameScene.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        
        
        
        /* Setup your scene here */
        
        
        let matrix = MatrixNode(numColumns: 3, numRows: 3)
        matrix.position = CGPoint(x: 0,y: 0)
        self.addChild(matrix)
        
        matrix.runAction(SKAction.rotateByAngle(CGFloat(M_PI_4), duration: 4))
        print(self.children)
        print(matrix.children)
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
