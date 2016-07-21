//
//  Player.swift
//  casarao
//
//  Created by Wagner Oliveira dos Santos on 7/19/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation

class Player: Hashable {
    
    static let sharedInstance = Player()
    
    var hashValue: Int {
        get {
            return NSUUID().UUIDString.hashValue
        }
    }
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var nickname:String?
    
    // amonut user coins default
    var coins:Double?
    
    var currentMatrix:MatrixNode?
    
 
    func updateUserDefaults(newCoins:Double) {
        coins = defaults.doubleForKey("coins")
        if (newCoins>coins) {
            defaults.setDouble(newCoins, forKey: "coins")
        }
    }
    
    
}

func ==(lhs:Player, rhs:Player) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

