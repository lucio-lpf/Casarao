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
}