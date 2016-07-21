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
    
    var players:Array<Player>?
    
    // hora que começa o game
    var startTime:NSDate?
    
    // montante das apostas
    var amount:Double?
    
    // aposta inicial
    var bet:Double?
    
    // matriz de resposta para cada player
    //TODO: trocar key para Player, Player deve implementar equatable
    
    private var answersMatrixPerUser:Dictionary<Int,MatrixNode>?
    
    
    func checkUserAnswer(answer:Array<Int>) -> (){
        
    }
    
}