//
//  GameRoom.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse

class GameRoom: PFObject, PFSubclassing {
    
    @NSManaged var roomName:String?
    
    @NSManaged var players:Array<Player>
    
    // hora que começa o game
    @NSManaged var startTime:NSDate?
    
    // montante das apostas
   @NSManaged var amount:NSNumber?
    
    // aposta inicial
   @NSManaged var bet:NSNumber?
    
    var status = "online"
    

    
    static func parseClassName() -> String {
        return "GameRoom"
    }
    
    convenience override init() {
        self.init(capacity:10)
    }

     init(capacity:Int) {
//        self.players = Array<Player>()
//        players.reserveCapacity(capacity)
        super.init()
    }
    
    // matriz de resposta para cada player
    
    
    func addPlayerToGame(player:Player) {
        // add player to game room
        self.players.append(player)
        
        var playerRandomArray = Array<Int>()
        var playerFreshArray = Array<Int>()
        for _ in 0..<9{
            playerRandomArray.append(Int(arc4random_uniform(3) + 1))
            playerFreshArray.append(0)
        }
        
        player.answerMatrix = playerRandomArray
        player.currentMatrix = playerFreshArray
        
    }
}
