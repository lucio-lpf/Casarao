//
//  SplashScene.swift
//  Decypher
//
//  Created by Lúcio Pereira Franco on 11/08/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import Foundation
import SpriteKit
import Parse


class SplashScene: SKScene {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var player:Player!
    
    
    override init(size: CGSize) {
        
        super.init(size: size)
        

    }
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        let allUsersPass = "P6xA5#72GacX;F]X"
        let userNickname = "GuestUser\(Int(arc4random_uniform(1000)))"
        
        
        if defaults.stringForKey("userKey") != nil{
            
            PFUser.logInWithUsernameInBackground(defaults.stringForKey("userKey")!, password: allUsersPass) {
                (pfuser, error) in
                
                if let e = error {
                    print(e.debugDescription)
                }else {
                    self.player = Player(pfuser: pfuser!)
                    self.player.nickname = userNickname
                    self.player.image = UIImage(named: "ProfilePlaceHolder")!
                    self.lobbyTransition()
                }
            }
        }
        else{
            let player = PFUser()
            defaults.setObject(String(UIDevice.currentDevice().identifierForVendor!), forKey: "userKey")
            player.username = defaults.stringForKey("userKey")!
            player.password = allUsersPass
            player.email = "\(UIDevice.currentDevice().identifierForVendor!)@teste.com"
            player.signUpInBackgroundWithBlock(){
                (bool, error) in
                if let e = error{
                    print(e.debugDescription)
                } else {
                    self.player = Player(pfuser: player)
                    self.player.nickname = userNickname
                    self.player.coins = 10
                    self.player.image = UIImage(named: "ProfilePlaceHolder")!
                    
                    self.lobbyTransition()
                }
            }
            

           
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lobbyTransition(){
        
        let transition:SKTransition = SKTransition.fadeWithDuration(0.5)
        let lobby:LobbyScene = LobbyScene(size: self.size)
        player.updateUserDefaults(player.coins!)
        lobby.player = player
        self.view!.presentScene(lobby, transition: transition)
    }
    
    func iCloudKeysChanged(sender: NSNotification) {
        
        // Update local store values
    }
}