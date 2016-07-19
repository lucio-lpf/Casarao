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
        

        let obj = self.childNodeWithName("tile11")
        
        loadButtons()
    }

    
    func loadButtons(){
    
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
