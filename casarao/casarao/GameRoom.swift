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
            return parseObject.value(forKey: "roomName") as? String
        }
        set{
            parseObject.setValue(newValue, forKey: "roomName")
            parseObject.saveInBackground()
        }

    }
    
    var players:Array<String>{
        
        get{
            return parseObject.value(forKey: "players") as! Array<String>
            
        }
        
        set{
            parseObject.setValue(newValue, forKey: "players")
            parseObject.saveInBackground()
        }
    }
    
    // hora que começa o game
    var startTime:Date!{
        get{
            return parseObject.value(forKey: "startTime") as! Date
        }
    }
    
    
    var timer:Int{
        
        get{
            return parseObject.value(forKey: "timer") as! Int
            
        }
        
        set{
            parseObject.setValue(newValue, forKey: "timer")
            parseObject.saveInBackground()
        }
    }
    
    // montante das apostas
    var amount:Int{
        get{
            return parseObject.value(forKey: "amount") as! Int
        }
        set{
            parseObject.setValue(newValue, forKey: "amount")
            parseObject.saveInBackground()
        }
    }
    
    // aposta inicial
    var bet:Int{
        get{
            return parseObject.value(forKey: "bet") as! Int
        }
    }
    
    var status:String{
        
        get{
           return parseObject.value(forKey: "estado") as! String
        }
        set{
            parseObject.setValue(newValue, forKey: "estado")
            parseObject.saveInBackground()
        }
        
    }
    var winner:Player?{
        get{
            let user = parseObject.value(forKey: "winner") as! PFUser
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
            return parseObject.value(forKey: "maxPlayers") as! Int
        }
    }
    
    
    var id:String{
        get{
            return parseObject.objectId!
        }
    }

    fileprivate var playTimesPerPlayer:Dictionary<String,TimeInterval>{
        get{
            return parseObject.value(forKey: "userPlayTime") as! Dictionary<String,TimeInterval>
        }
    }
    
    func timeOfLastUserPlay(_ playerId:String) -> TimeInterval?{

        if let time = playTimesPerPlayer[playerId]{
            return Date().timeIntervalSince1970 - time/1000
        }
        
        return nil
        
    }
    
    var parseObject: PFObject
    
    
    var playerRightMatrix:Dictionary<String,Array<Int>>{
        get{
            return parseObject.value(forKey: "userRightMatrix") as! Dictionary<String,Array<Int>>
        }
    }
    
    var playerMatrix:Dictionary<String,Array<Int>>{
        get{
            return parseObject.value(forKey: "userMatrix") as! Dictionary<String,Array<Int>>
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
