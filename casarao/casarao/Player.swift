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
    
    var currentMatrix:MatrixNode?
    
 
    func updateUserDefaults(newCoins:Double) {
        coins = defaults.doubleForKey("coins")
        if (newCoins>coins) {
            defaults.setDouble(newCoins, forKey: "coins")
        }
    }
}

