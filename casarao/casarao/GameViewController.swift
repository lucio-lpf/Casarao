//
//  GameViewController.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright (c) 2016 'team'. All rights reserved.
//

import UIKit
import SpriteKit
import Parse

class GameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        let lobbyScene = LobbyScene(size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
        lobbyScene.scaleMode = .AspectFill
        skView.presentScene(lobbyScene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
