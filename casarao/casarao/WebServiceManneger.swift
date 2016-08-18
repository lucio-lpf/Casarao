//
//  WebServiceManneger.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse


class WebServiceManager {
    static let sharedInstance = WebServiceManager()
    
    
    static func returnGameRooms(callBack:(GameRooms:Array<GameRoom>)->()){
        
        var gameRoomsArray: Array<GameRoom>= []
        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("estado", equalTo: "waiting")
        parseQuery.includeKey("players")
        parseQuery.findObjectsInBackgroundWithBlock { (PFObjects, error) in
            if let e = error{
                print(e.debugDescription)
            }
            else{
                for object in PFObjects!{
                    gameRoomsArray.append(GameRoom(pfobject: object))
                }
                callBack(GameRooms: gameRoomsArray)
            }
        }
    }
    
    static func addUserToRoom(player:PFUser,room:PFObject,callBack: (Bool)->()){
        print(room.objectId!)
        PFCloud.callFunctionInBackground("addUserToRoom", withParameters: ["player":player.objectId!, "room":room.objectId!]) { (response, error) in
            guard error != nil else{
                print(response.debugDescription)
                callBack(true)
                return
            }
            print(error.debugDescription)
            callBack(false)
            
        }
    }
    static func checkUserMatrix(player:PFUser,room:PFObject, callBack: (Bool)->()){
        PFCloud.callFunctionInBackground("addUserToRoom", withParameters: ["player":player, "room":room]) { (response, error) in
            callBack(true)
        }
    }
}