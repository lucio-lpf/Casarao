//
//  GameRoom.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation

class GameRoom {
    
    var roomName:String?
    
    var players:Array<Player>
    
    // hora que começa o game
    var startTime:NSDate?
    
    // montante das apostas
    var amount:Double?
    
    // aposta inicial
    var bet:Double?

    
    
    convenience init(){
        self.init(capacity:10)
    }
    
    init(capacity:Int) {
        self.players = Array<Player>()
        players.reserveCapacity(capacity)
    }
    
    // matriz de resposta para cada player
    private var answersMatrixPerUser = Dictionary<Player,Array<Int>>()
    
    func checkUserAnswer(answer:Array<Tile>,selfPlayer:Player) -> (rightAnswers:Array<Int>,didFinishTheGame:Bool){

        
        
        for key in self.answersMatrixPerUser.keys {
            print(key)
            print("")
            print(selfPlayer)
        }
        
        
        
        if let m = self.answersMatrixPerUser[selfPlayer] {
            print(m.count)
        }

        let righMatrix = self.answersMatrixPerUser[selfPlayer]
        
        print(self.answersMatrixPerUser[selfPlayer])
        var contAnswers = Array<Int>()
        
        for i in 0..<righMatrix!.count{
        
            if righMatrix![i] == answer[i].colorNumber{
                contAnswers.append(i)
            }
        }
        
        if contAnswers.count == righMatrix!.count{
            return(contAnswers,true)
        }
        else{
            return(contAnswers,false)
        }
    }
    
    func addPlayerToGame(player:Player) {
        // add player to game room
        self.players.append(player)
        
        var playerRandomArray = Array<Int>()
        for _ in 0..<9{
            playerRandomArray.append(Int(arc4random_uniform(3) + 1))
        }
        
        self.answersMatrixPerUser[player] = playerRandomArray
        
    }
}
