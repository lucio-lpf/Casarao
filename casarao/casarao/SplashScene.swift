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
    
    
    
    var player:Player!
    
    
    override init(size: CGSize) {
        
        super.init(size: size)
        

    }
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        //CHECK CURRENT USER
        let allUsersPass = "P6xA5#72GacX;F]X"
        let userNickname = "GuestUser\(Int(arc4random_uniform(1000)))"
        
        
        // init user
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.player = Player(pfuser: currentUser!)
            self.player.coins = 10
            lobbyTransition()
            
        } else {
            PFUser.logInWithUsernameInBackground(String(UIDevice.currentDevice().identifierForVendor!), password: allUsersPass) {
                (pfuser, error) in
                
                if let e = error {
                    print(e.debugDescription)
                    let player = PFUser()
                    player.username = String(UIDevice.currentDevice().identifierForVendor!)
                    player.password = allUsersPass
                    player.email = "\(UIDevice.currentDevice().identifierForVendor!)@teste.com"
                    player.signUpInBackgroundWithBlock(){
                        (bool, error) in
                        if let e = error{
                            print(e.debugDescription)
                        } else {
                            self.player = Player(pfuser: player)
                            self.player.coins = 10
                            self.player.nickname = userNickname
                            self.player.image = UIImage(named: "ProfilePlaceHolder")!
                            
                            self.lobbyTransition()
                        }
                    }
                } else {
                    self.player = Player(pfuser: pfuser!)
                    self.player.coins = 10
                    self.player.nickname = userNickname
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
        lobby.player = player
        self.view!.presentScene(lobby, transition: transition)
    }
}