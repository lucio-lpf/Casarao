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
    
    let defaults = UserDefaults.standard
    
    var player:Player!
    
    static var notificationPlayer:Player?
    
    static var nextSceneIsOn: String?
    
    static var gameRoomTargetId: String?
    

    
    override init(size: CGSize) {
        
        super.init(size: size)
        

    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
  
        let allUsersPass = "P6xA5#72GacX;F]X"
        let userNickname = "GuestUser\(Int(arc4random_uniform(1000)))"
        
        
        if defaults.string(forKey: "userKey") != nil{
            
            PFUser.logInWithUsername(inBackground: defaults.string(forKey: "userKey")!, password: allUsersPass) {
                (pfuser, error) in
                
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    self.player = Player(pfuser: pfuser!)
                    self.lobbyTransition()
                }
            }
        }
        else{
            let player = PFUser()
            defaults.set(String(describing: UIDevice.current.identifierForVendor!), forKey: "userKey")
            player.username = defaults.string(forKey: "userKey")!
            player.password = allUsersPass
            defaults.set(false, forKey: "tutorial")
            player.email = "\(UIDevice.current.identifierForVendor!)@teste.com"
            player.signUpInBackground(){
                (bool, error) in
                if let e = error{
                    print(e.localizedDescription)
                } else {
                    self.player = Player(pfuser: player)
                    self.player.nickname = userNickname
                    self.player.coins = 1000
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
        
        if let gameRoom = SplashScene.gameRoomTargetId{
            
            WebServiceManager.getGameRoomFromId(gameRoom, callBack: { (GameRoom) in
                let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                self.player.updateUserDefaults(self.player.coins!)
                let gameScene:GameScene = GameScene(size: self.size, player: self.player, gameRoom: GameRoom)
                self.view!.presentScene(gameScene, transition: transition)
            })
            
            
        }
            
        else{
            let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
            let lobby:LobbyScene = LobbyScene(size: self.size)
            player.updateUserDefaults(player.coins!)
            lobby.player = player
            self.view!.presentScene(lobby, transition: transition)
        }
        
        
    }
    
    
    func iCloudKeysChanged(_ sender: Notification) {
        
        // Update local store values
    }
    
    
  /*  <wpt lat="-30.058035" lon="-51.174231">
    <time>2016-08-04T18:32:23Z</time>
    </wpt>
    
    <wpt lat="-30.059679" lon="-51.175336">
    <time>2016-08-04T18:32:33Z</time>
    </wpt>
    
    
    <wpt lat="-30.061331" lon="-51.175046">
    <time>2016-08-04T18:32:43Z</time>
    </wpt>
    
    <wpt lat="-30.061192" lon="-51.173490">
    <time>2016-08-04T18:32:53Z</time>
    </wpt>
    
    <wpt lat="-30.060644" lon="-51.174338">
    <time>2016-08-04T18:33:03Z</time>
    </wpt>
    
    <wpt lat="-30.059920" lon="-51.173630">
    <time>2016-08-04T18:33:13Z</time>
    </wpt>
    <wpt lat="-30.059224" lon="-51.173952">
    <time>2016-08-04T18:33:23Z</time>
    </wpt>
    
    <wpt lat="-30.059809" lon="-51.171688">
    <time>2016-08-04T18:33:43Z</time>
    </wpt>
 
 */

}
