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
    
    
    let defaults = UserDefaults.standard
    
    var nickname:String?{
        get{
            return parseUser.value(forKey: "nickname") as? String
        }
        set{
            parseUser.setValue(newValue, forKey: "nickname")
            parseUser.saveInBackground()
        }
    }

    
    // amonut user coins default
    var coins:Int?{
        get{
            return parseUser.value(forKey: "coins") as? Int
        }
        set{
            parseUser.setValue(newValue, forKey: "coins")
            parseUser.saveInBackground()
        }
    }
    
    
    var username:String?{
        get{
            return parseUser.value(forKey: "username") as? String
        }
    }


    var image:UIImage? {
        get {
            do {
                let userImageFile = parseUser.object(forKey: "profileImage") as? PFFile
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
                parseUser.remove(forKey: "profileImage")
            }
        }
    }
    
    
    func getPictureInBackground(_ block: @escaping (UIImage) -> Void) {
        
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var pic = UIImage()
            if let verifiedPic = self.image{
                pic = verifiedPic
            }
            else{
                pic = UIImage(named: "ProfilePlaceHolder")!
            }
            DispatchQueue.main.async {
                block(pic)
            }
        }
    }
    
 
    var parseUser: PFUser
    
    
    
    func updateUserDefaults(_ newCoins:Int) {
        defaults.set(newCoins, forKey: "coins")
    }
    
    
    
    init(pfuser:PFUser) {
        
        parseUser = pfuser
    }
    
    var id:String{
        get{
            return parseUser.objectId!
        }
    }
    
    func updateNickname(_ newValue:String,callBack:@escaping (Bool)->Void){
        parseUser["nickname"] = newValue
        parseUser.saveInBackground { (bool, error) in
            callBack(bool)
        }
    }
}

