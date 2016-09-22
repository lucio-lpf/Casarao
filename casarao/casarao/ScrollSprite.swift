//
//  ScrollSprite.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 12/08/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit


class ScrollSprite: SKSpriteNode{
    
    
    
    
    var gameRooms:[GameRoomSpriteNode]?
    var selectedGameRoom:GameRoomSpriteNode!
    var selectGameRoom:Bool!
    
    var swipeDown: UISwipeGestureRecognizer!
    
    
    init(size:CGSize,gameRooms:[GameRoomSpriteNode]){
        
        self.gameRooms = gameRooms
        super.init(texture: nil, color: SKColor.blue, size: size)
        isUserInteractionEnabled = true
        addGameRooms()
        
        
    }
    

    func addGameRooms(){
        var yposition = self.size.height/2
        for x in 0 ..< gameRooms!.count{
            gameRooms![x].position = CGPoint(x: 0, y: yposition)
            gameRooms![x].zPosition = 3
            yposition -= 80
            addChild(gameRooms![x])
            
        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameRooms != nil{
            let touch = touches.first!
            let point = touch.location(in: self)
            for gameRoom in gameRooms!{
                
                if gameRoom.contains(point){
                    
                    self.selectGameRoom = true
                    selectedGameRoom = gameRoom
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        selectGameRoom = false
      //  let firstTouch = touches.first
        for touch in touches{
         print(touch.location(in: self))
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if selectGameRoom == true{
            
            let parenteScene = parent! as! LobbyScene
            parenteScene.joinGame(selectedGameRoom.gameRoom)
            
        }
        else{
            
        }
        
    }
    
    
    
    
}
