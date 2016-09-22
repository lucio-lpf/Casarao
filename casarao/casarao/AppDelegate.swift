//
//  AppDelegate.swift
//  casarao
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
/*
    # Uncomment this line to define a global platform for your project
    # platform :ios, '9.0'
    
    target 'Decypher' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    pod 'Parse'
    pod 'Alamofire', '~> 3.4'
    pod 'AlamofireObjectMapper', '~> 3.0'
    
    # Pods for casarao
    target 'DecypherTests' do
    inherit! :search_paths
    # Pods for testing
    end
    
    target 'DecypherUITests' do
    inherit! :search_paths
    # Pods for testing
    end
    
    end

*/
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        let configuration = ParseClientConfiguration{
            $0.applicationId = "HSYwTD8Cz0O2cznV9J7jSCBmdR38X6EF"
            $0.clientKey = "y5NPYdVS50Ts96N5O0iLrPZlFX7ULy1L"
            $0.server = "https://decypher.tk/parse"
            $0.localDatastoreEnabled = true
        }
        Parse.initializeWithConfiguration(configuration)
        
        
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        if let options = launchOptions {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                if let userInfo = notification.userInfo {
                    if let gameRoomId = userInfo["gameRoomId"]{
                        print(gameRoomId)
                        SplashScene.gameRoomTargetId = gameRoomId.description
                    }
                }
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation?.setDeviceTokenFromData(deviceToken)
        installation?.channels = ["global"]
        installation?.saveInBackground()
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            let customField1 = userInfo["gameRoomId"] as! String
            SplashScene.gameRoomTargetId = customField1
            print("didReceiveLocalNotification: \(customField1)")
        }
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
