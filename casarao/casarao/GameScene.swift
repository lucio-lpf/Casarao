//
//  GameScene.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var rightTileMatrix = Array<Array<Tile>>()
    var userTileMatrix = Array<Array<Tile>>()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        loadButtons()
        
    }

    
    func loadButtons(){
    
        userTileMatrix
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
