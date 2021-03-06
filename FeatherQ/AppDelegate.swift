//
//  AppDelegate.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 21/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.registerForPushNotifications(application)
        
        IQKeyboardManager.sharedManager().enable = true
        
        UITabBar.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UIButton.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UITableView.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UINavigationBar.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */ // set a universal tint color for all views depending on app motiff
        UISegmentedControl.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.loadIsCalledBool()
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FQLoaderViewController")
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == .Active {
            debugPrint(userInfo["aps"]!)
            let actionType = userInfo["aps"]!["msg_type"] as! String
            if actionType == "call" {
                Session.instance.callingTerminal = userInfo["aps"]!["terminal_name"] as! String
                self.saveIsCalledBool(true, callingTerminal: Session.instance.callingTerminal)
                let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FQModalViewController") as! FQModalViewController
                modalViewController.modalPresentationStyle = .OverCurrentContext
                self.window?.currentViewController()?.presentViewController(modalViewController, animated: true, completion: nil)
            }
            else {
                self.saveIsCalledBool(false, callingTerminal: "")
            }
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Device Token (raw): \(deviceToken)")
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Device Token (string):", tokenString)
        Session.instance.deviceToken = tokenString
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func loadIsCalledBool() {
        let preferences = NSUserDefaults.standardUserDefaults()
        if preferences.boolForKey("isCalled") == true {
            Session.instance.isCalled = true
            Session.instance.callingTerminal = preferences.stringForKey("callingTerminal")!
        }
    }
    
    func saveIsCalledBool(boolVal: Bool, callingTerminal: String) {
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.setValue(boolVal, forKey: "isCalled")
        preferences.setValue(callingTerminal, forKey: "callingTerminal")
        preferences.synchronize()
        Session.instance.isCalled = boolVal
    }

}

