//
//  GameRoom.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse

class GameRoom {
    
    var roomName:String?
    
    var players:Array<Player>
    
    // hora que começa o game
    var startTime:NSDate?
    
    // montante das apostas
    var amount:Double?
    
    // aposta inicial
    var bet:Double?
    
    var status = "online"
    
    convenience init(){
        self.init(capacity:10)
    }
    
    init(capacity:Int) {
        self.players = Array<Player>()
        players.reserveCapacity(capacity)
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
