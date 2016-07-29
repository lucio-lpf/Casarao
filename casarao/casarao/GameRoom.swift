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
    
    var players:Array<Player>{
        
        get{
            let pfusers =  parseObject.valueForKey("players") as? Array<PFUser>
            var playerArray:Array<Player> = []
            if pfusers != nil{
                for user in (pfusers)!{
                    playerArray.append(Player(pfuser: user))
                }
            }
            
            return playerArray
        }
        set{
            var userArray:Array<PFUser> = []
            for player in newValue{
                userArray.append(player.parseUser)
            }
            parseObject.setValue(userArray, forKey: "players")
            parseObject.saveInBackground()
        }
    }
    
    // hora que começa o game
    var startTime:NSDate?{
        get{
            return parseObject.valueForKey("startTime") as? NSDate
        }
    }
    
    // montante das apostas
    var amount:Int{
        get{
            return parseObject.valueForKey("amount") as! Int
        }
        set{
            parseObject.setValue(newValue, forKey: "amount")
            parseObject.saveInBackground()
        }
    }
    
    // aposta inicial
    var bet:Int{
        get{
            return parseObject.valueForKey("bet") as! Int
        }
    }
    
    var status:String{
        
        get{
           return parseObject.valueForKey("estado") as! String
        }
        
    }
    
    
    var maxPlayers:Int{
        
        get{
            return parseObject.valueForKey("maxPlayers") as! Int
        }
    }

    
    var parseObject: PFObject
    
    
    
    
    init(pfobject:PFObject){
        
        parseObject = pfobject
        
    }
    // matriz de resposta para cada player
    
    
    func addPlayerToGame(player:Player) {
        // add player to game room
        self.players.append(player)
        amount += bet
        
        var playerRandomArray = Array<Int>()
        var playerFreshArray = Array<Int>()
        for _ in 0..<9{
            playerRandomArray.append(Int(arc4random_uniform(3) + 1))
            playerFreshArray.append(0)
        }
        
        player.answerMatrix = playerRandomArray
        player.currentMatrix = playerFreshArray
        
    }
    
    func firstPlaceGame()->(Player){
        
        var firstPlayer = players[0]
        
        for player in players{
            
            if player.numberOfUserRightAnswers() > firstPlayer.numberOfUserRightAnswers(){
                firstPlayer = player
            }
        }
        
        return firstPlayer
        
        
    }
}
