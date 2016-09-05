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
        parseQuery.whereKey("estado", notEqualTo: "finished")
        parseQuery.orderByAscending("roomName")
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
    
    static func addUserToRoom(playerId:String,roomId:String,callBack: (Bool)->()){
        PFCloud.callFunctionInBackground("addUserToRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
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
    
    
    static func checkUserMatrix(playerId:String,roomId:String,playerMatrixArray:Array<Int>, callBack: (playerArray:Array<Int>?,winner:String?)->()){
        PFCloud.callFunctionInBackground("checkUserMatrix", withParameters: ["player":playerId, "room":roomId,"playerMatrixArray": playerMatrixArray]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                
                switch(responseObject["Code"] as! Int){
                
                    case 0:
                        
                        print(responseObject["Messenge"])
                        callBack(playerArray: responseObject["NewArray"] as? Array<Int>, winner: nil)
                        break
                        
                    case 1:
                        
                        print(responseObject["Messenge"])
                        callBack(playerArray: responseObject["NewArray"] as? Array<Int>, winner: responseObject["Winner"] as? String)
                        break
                        
                    case 2:
                        
                        print(responseObject["Messenge"])
                        callBack(playerArray: nil, winner: nil)
                        
                        break
                    case 3:
                        
                        print(responseObject["Messenge"])
                        callBack(playerArray: nil, winner: responseObject["Winner"] as? String)
                        
                        break
                        
                    default:
                        fatalError()
                    }
                
                return
            }
            print(error?.userInfo["error"])
            callBack(playerArray: nil,winner: nil)
        }
    }
    
    static func checkIfUserIsInRoom(playerId:String,roomId:String, callBack: (Bool)->()){
        PFCloud.callFunctionInBackground("checkIfUserIsInRoom", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
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
    
    
    static func roomScoreTable(roomId:String,callBack:(Dictionary<String,Int>?)->()){
        
        PFCloud.callFunctionInBackground("roomScoreTable", withParameters: ["room":roomId]) { (response, error) in
            guard error != nil else{
                let responseObject = response as! NSDictionary
                print(responseObject["ScorePerUser"])
                callBack(responseObject["ScorePerUser"] as? Dictionary<String,Int>)
                return
            }
            print(error?.userInfo["error"])
            callBack(nil)
        }

        
    }
    static func checkUserPlayTimer(playerId:String, roomId:String,callBack:(Bool,Int?)->()){
        
        print("entrei na funçao")
        PFCloud.callFunctionInBackground("checkUserPlayTimer", withParameters: ["player":playerId, "room":roomId]) { (response, error) in
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