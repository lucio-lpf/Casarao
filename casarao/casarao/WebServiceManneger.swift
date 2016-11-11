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
    
    
    static func returnGameRooms(_ filterType:String, roomType:String, callBack:@escaping (_ GameRooms:Array<GameRoom>)->()){
        
        var gameRoomsArray: Array<GameRoom>= []
        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("estado", notEqualTo: "finished")
        if filterType == "None"{
            parseQuery.order(byAscending: "roomName")}
        else{
            parseQuery.order(byAscending: filterType)
        }
        parseQuery.whereKey("Type", equalTo: roomType)
        parseQuery.includeKey("players")
        parseQuery.findObjectsInBackground { (PFObjects, error) in
            if let e = error{
                print(e.localizedDescription)
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
                print(e.localizedDescription)
            }else{
                print(PFObjects ?? 10)
               let  gameRoom = GameRoom(pfobject: PFObjects![0])
                callBack(gameRoom)
                
            }
           
        }
    }
    
    
    static func creatNewRoom(_ playerId:String,roomId:String,callBack: @escaping (Bool)->()){
        
        PFCloud.callFunction(inBackground: "creatPlayerRoom", withParameters: ["player":playerId, "roomName":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"] ?? 10
                )
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.localizedDescription ?? 10)
            callBack(false)
        }
        
    }
    
    static func addUserToRoom(_ playerId:String,roomId:String,callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "addUserToRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"] ?? 10)
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.localizedDescription ?? 10)
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
                        
                        print(responseObject["Messenge"] ?? 10)
                        callBack(responseObject["NewArray"] as? Array<Int>, nil,newParseObject)
                        break
                        
                    case 1:
                        
                        print(responseObject["Messenge"] ?? 10)
                        callBack(responseObject["NewArray"] as? Array<Int>, responseObject["Winner"] as? String,nil)
                        break
                        
                    case 2:
                        
                        print(responseObject["Messenge"] ?? 10)
                        callBack(nil, nil,nil)
                        
                        break
                    case 3:
                        
                        print(responseObject["Messenge"] ?? 10)
                        callBack(nil, responseObject["Winner"] as? String,nil)
                        
                        break
                        
                    default:
                        fatalError()
                    }
                
                return
            }
            print(error?.localizedDescription ?? 10)
        }
    }
    
    static func checkIfUserIsInRoom(_ playerId:String,roomId:String, callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "checkIfUserIsInRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"] ?? 10)
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.localizedDescription ?? 10)
            callBack(false)
        }
    }
    
    //*/5 * * * * /home/ubuntu/ParseServer/parse/api/cloud/main.js roomScoreTable
    
    static func roomScoreTable(_ playerId:String,roomId:String, callBack: @escaping (Bool)->()){
        PFCloud.callFunction(inBackground: "roomScoreTable", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["Messenge"] ?? 10)
                if (responseObject["Code"] as! Int) == 0{
                    callBack(true)
                }
                else{
                    callBack(false)
                }
                
                return
            }
            print(error?.localizedDescription ?? 10)
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
                print(e.localizedDescription)
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
                print(responseObject["Messenge"] ?? 10)
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
            print(error?.localizedDescription ?? 10)
            fatalError()
        
        
        }
    }
}
