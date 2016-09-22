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
    
    
    static func returnGameRooms(_ callBack:@escaping (_ GameRooms:Array<GameRoom>)->()){
        
        var gameRoomsArray: Array<GameRoom>= []
        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("estado", notEqualTo: "finished")
        parseQuery.order(byAscending: "roomName")
        parseQuery.includeKey("players")
        parseQuery.findObjectsInBackground { (PFObjects, error) in
            if let e = error{
                print(e.debugDescription)
            }
            else{
                for object in PFObjects!{
                    gameRoomsArray.append(GameRoom(pfobject: object))
                }
                callBack(gameRoomsArray)
            }
        }
    }
    static func getGameRoomFromId(_ gameRoomId:String, callBack:@escaping (_ GameRoom:GameRoom)->()){
        
        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("obejctId", equalTo: gameRoomId )
        parseQuery.includeKey("players")
        parseQuery.findObjectsInBackground { (PFObjects, error) in
            if let e = error{
                print(e.debugDescription)
            }else{
                print(PFObjects)
               let  gameRoom = GameRoom(pfobject: PFObjects![0])
                callBack(gameRoom)
                
            }
           
        }
    }
    
    
    static func addUserToRoom(_ playerId:String,roomId:String,callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "addUserToRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"])
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error.debugDescription)
            callBack(false)
        }
    }
    
    
    static func checkUserMatrix(_ playerId:String,roomId:String,playerMatrixArray:Array<Int>, callBack: @escaping (_ playerArray:Array<Int>?,_ winner:String?,_ newObject:PFObject?)->()){
        PFCloud.callFunction(inBackground: "checkUserMatrix", withParameters: ["player":playerId, "room":roomId,"playerMatrixArray": playerMatrixArray]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                
                let newParseObject = responseObject["NewRoomObject"] as? PFObject
                
                switch(responseObject["Code"] as! Int){
                
                    case 0:
                        
                        print(responseObject["Messenge"])
                        callBack(responseObject["NewArray"] as? Array<Int>, nil,newParseObject)
                        break
                        
                    case 1:
                        
                        print(responseObject["Messenge"])
                        callBack(responseObject["NewArray"] as? Array<Int>, responseObject["Winner"] as? String,nil)
                        break
                        
                    case 2:
                        
                        print(responseObject["Messenge"])
                        callBack(nil, nil,nil)
                        
                        break
                    case 3:
                        
                        print(responseObject["Messenge"])
                        callBack(nil, responseObject["Winner"] as? String,nil)
                        
                        break
                        
                    default:
                        fatalError()
                    }
                
                return
            }
            print(error?.userInfo["error"])
        }
    }
    
    static func checkIfUserIsInRoom(_ playerId:String,roomId:String, callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "checkIfUserIsInRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"])
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.userInfo["error"])
            callBack(false)
        }
    }
    
    static func roomScoreTable(_ playerId:String,roomId:String, callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "roomScoreTable", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"])
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.userInfo["error"])
            callBack(false)
        }
    }
    
    
    
    static func updateUserRooms(_ playerId:String,callBack:@escaping (Array<GameRoom>)->()){
        
        
        var gameRoomsArray: Array<GameRoom>= []
        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("estado", equalTo: "playing")
        parseQuery.whereKey("players", containedIn: [playerId])
        parseQuery.findObjectsInBackground { (PFObjects, error) in
            if let e = error{
                print(e.debugDescription)
            }
            else{
                for object in PFObjects!{
                    gameRoomsArray.append(GameRoom(pfobject: object))
                }
                callBack(gameRoomsArray)
            }
        }
    }
    static func checkUserPlayTimer(_ playerId:String, roomId:String,callBack:@escaping (Bool,Int?)->()){
        
        print("entrei na funçao")
        PFCloud.callFunction(inBackground: "checkUserPlayTimer", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"])
                switch (responseObject["Code"] as! Int){
                case 0:
                    callBack(true,nil)
                    
                    break
                    
                case 1:
                    
                    callBack(false,responseObject["TimeLeft"] as? Int)
                    
                    break
                default:
                    
                    fatalError()
                    
                    break
                    
                }
                
                return
            }
            print(error?.userInfo["error"])
            fatalError()
        
        
        }
    }
}
