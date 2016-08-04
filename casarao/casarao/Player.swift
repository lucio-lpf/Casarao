//
//  Player.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import Parse

class Player {
    
    
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
    var coins:Int?{
        get{
            return parseUser.valueForKey("coins") as? Int
        }
        set{
            parseUser.setValue(newValue, forKey: "coins")
            parseUser.saveInBackground()
        }
    }
    
    
    var username:String?{
        get{
            return parseUser.valueForKey("username") as? String
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
    
    var image:NSData? {
        get {
            var data:NSData?
            if let file = parseUser.valueForKey("profileImage") as? PFFile {
                do{
                    // synchronously
                    data = try file.getData()
                } catch{
                    data = nil
                }
            }
            return data
        }
        
        set {
            if let data = newValue {
                let file = PFFile(data: data)
                file?.saveInBackgroundWithBlock() {
                    [unowned self] (saved, error) in
                    
                    self.parseUser.setValue(file!, forKey: "profileImage")
                    self.parseUser.saveInBackground()
                }
            }
        }
    }
    
 
    var parseUser: PFUser
    
    
    
    func updateUserDefaults(newCoins:Int) {
        coins = defaults.integerForKey("coins")
        if (newCoins>coins) {
            defaults.setInteger(newCoins, forKey: "coins")
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

