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
    
    var image:UIImage? {
        get {
            do {
                let userImageFile = parseUser.objectForKey("profileImage") as? PFFile
                let data = try userImageFile?.getData()
                if let data = data {
                    return UIImage(data: data)
                }
                else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        
        set {
            if let newValue = newValue {
                let imageData = UIImageJPEGRepresentation(newValue, 0.05)
                let imageFile = PFFile(name:"profileImage.jpg", data:imageData!)
                parseUser.setObject(imageFile!, forKey: "profileImage")
            } else {
                parseUser.removeObjectForKey("profileImage")
            }
        }
    }
    
    
    func getPictureInBackground(block: (UIImage) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var pic = UIImage()
            if let verifiedPic = self.image{
                pic = verifiedPic
            }
            else{
                pic = UIImage(named: "ProfilePlaceHolder")!
            }
            dispatch_async(dispatch_get_main_queue()) {
                block(pic)
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

