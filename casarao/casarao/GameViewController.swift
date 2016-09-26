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
        skView.isMultipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        let splashScene = SplashScene(size: UIScreen.main.bounds.size)
        splashScene.scaleMode = .aspectFit
        skView.presentScene(splashScene)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
