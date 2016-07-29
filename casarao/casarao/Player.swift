//
//  Player.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse

class Player{
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var nickname:String?{
        get{
            return parseUser.valueForKey("nickname") as? String
        }
        set{
            parseUser.setValue(newValue, forKey: "nickname")
            parseUser.saveInBackground()
        }
    }

    
    // amonut user coins default
    var coins:Double?{
        get{
            return parseUser.valueForKey("coins") as? Double
        }
        set{
            parseUser.setValue(newValue, forKey: "coins")
            parseUser.saveInBackground()
        }
    }

    
    var currentMatrix:Array<Int>?{
        get{
            return parseUser.valueForKey("currentMatrix") as? Array<Int>
        }
        set{
            parseUser.setValue(newValue, forKey: "currentMatrix")
            parseUser.saveInBackground()
        }
    }

    
    var answerMatrix:Array<Int>?{
        get{
            return parseUser.valueForKey("answerMatrix") as? Array<Int>
        }
        set{
            parseUser.setValue(newValue, forKey: "answerMatrix")
            parseUser.saveInBackground()
        }
    }
    
 
    var parseUser: PFUser
    
    
    
    
    
    
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
    
    
    init(pfuser:PFUser) {
        
        parseUser = pfuser
    }
    
    
    func numberOfUserRightAnswers()->Int{
        
        var countScore = 0
        for i in 0..<currentMatrix!.count{
            
            if currentMatrix![i] == answerMatrix![i]{
                countScore += 1
            }
        }
        return(countScore)
    }
    
}

