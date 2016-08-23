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
        set{
            parseObject.setValue(newValue, forKey: "estado")
            parseObject.saveInBackground()
        }
        
    }
    var winner:Player?{
        get{
            let user = parseObject.valueForKey("winner") as! PFUser
            return Player(pfuser: user)
        }
        set{
            
            let player = newValue 
            parseObject.setValue(player!.parseUser, forKey: "winner")
            parseObject.saveInBackground()
        }
    }
    
    
    var maxPlayers:Int{
        
        get{
            return parseObject.valueForKey("maxPlayers") as! Int
        }
    }
    
    
    var id:String{
        get{
            return parseObject.objectId!
        }
    }

    
    var parseObject: PFObject
    
    
    var playerRightMatrix:Dictionary<String,Array<Int>>{
        get{
            return parseObject.valueForKey("userRightMatrix") as! Dictionary<String,Array<Int>>
        }
    }
    
    var playerMatrix:Dictionary<String,Array<Int>>{
        get{
            return parseObject.valueForKey("userMatrix") as! Dictionary<String,Array<Int>>
        }
        set{
            
            parseObject.setValue(newValue, forKey: "winner")
            parseObject.saveInBackground()
        }
    }

    
    init(pfobject:PFObject){
        
        parseObject = pfobject
        
    }
    // matriz de resposta para cada player
    
    

}
