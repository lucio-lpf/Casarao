//
//  GameRoom.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse

class GameRoom{
    
    var roomName:String?{
        get{
            return parseObject.valueForKey("roomName") as? String
        }
        set{
            parseObject.setValue(newValue, forKey: "roomName")
            parseObject.saveInBackground()
        }

    }
    
    var players: Array<Player>{
        get{
            let pfusers =  parseObject.valueForKey("players") as? Array<PFUser>
            var playerArray:Array<Player> = []
            for user in pfusers!{
                playerArray.append(Player(pfuser: user))
            }
            return playerArray
        }
        set{
            
            let userArray:Array<PFUser> = []
            
            for player in players{
                
            }
            parseObject.setValue(newValue, forKey: "players")
            parseObject.saveInBackground()
        }
    }
    
    // hora que começa o game
    @NSManaged var startTime:NSDate?
    
    // montante das apostas
   @NSManaged var amount:NSNumber?
    
    // aposta inicial
   @NSManaged var bet:NSNumber?
    
    var status = "online"
    

    
    var parseObject: PFObject
    
    
    
    
    init(pfobject:PFObject){
        
        parseObject = pfobject
        
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
