//
//  Player.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation

class Player {
    
    static let sharedInstance = Player()
    
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var nickname:String?
    
    // amonut user coins default
    var coins:Double?
    
    var currentMatrix:Array<Int>?
    
    var answerMatrix:Array<Int>?
    
 
    func updateUserDefaults(newCoins:Double) {
        coins = defaults.doubleForKey("coins")
        if (newCoins>coins) {
            defaults.setDouble(newCoins, forKey: "coins")
        }
    }
    
    func checkUserAnswer() -> (tileRight:Array<Int>,didFinishTheGame:Bool) {
        
        var countScore = 0
        var tilesRight = Array<Int>()
        
        for i in 0..<currentMatrix!.count{
            
            if currentMatrix![i] == answerMatrix![i]{
                countScore += 1
                tilesRight.append(i)
            }
            else{
                currentMatrix![i] = 0
            }
            
        }
        
        if countScore == answerMatrix!.count{
            return(tilesRight,true)
        }
        else{
            return(tilesRight,false)
        }
    }
    
}

