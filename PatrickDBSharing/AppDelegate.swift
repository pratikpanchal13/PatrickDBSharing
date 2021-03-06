//
//  AppDelegate.swift
//  PatrickDBSharing
//
//  Created by indianic on 12/04/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
    DropboxClientsManager.setupWithAppKey("8h6mnc3xdd3r15g")
        
        
//        let appKey = "8h6mnc3xdd3r15g"      // Set your own app key value here.
//        let appSecret = "hbwr5u55m0d1yjr"   // Set your own app secret value here.
//        
//        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootAppFolder)
//        DBSession.setSharedSession(dropboxSession)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        
//        if let authResult = DropboxClientsManager.handleRedirectURL(url as URL) {
//            switch authResult {
//            case .success(let token):
//                print("Success! User is logged into Dropbox.")
//            case .error(let error, let description):
//                print("Error: \(description)")
//            default:
//                break
//            }
//        }
//        
//        return false
//    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Dropboxlistrefresh"), object: nil)

                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }


}

