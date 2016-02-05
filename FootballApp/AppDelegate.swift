//
//  AppDelegate.swift
//  FootballApp
//
//  Created by Tomer Ciucran on 2/3/16.
//  Copyright © 2016 Apps4Gaps. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

let firebaseUrl = "https://resplendent-torch-3135.firebaseio.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            // TODO:Token is already available.
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
        }
        
        setRootViewController()
        
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, didFinishLaunchingWithOptions: launchOptions)
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
    }
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: String?, annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance()
                .application(application, openURL: url,
                    sourceApplication: sourceApplication, annotation: annotation)
    }
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    internal func setRootViewController() {
        // Check if user logged in
        if NSUserDefaults.standardUserDefaults().boolForKey("loggedIn") {
            
            if let userId = NSUserDefaults.standardUserDefaults().stringForKey("uid") {
                
                setLoadingAsRootViewController()
                let userRef = Firebase(url: "https://resplendent-torch-3135.firebaseio.com/users/\(userId)")
                userRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                    let favouriteCountry = snapshot.value.objectForKey("favourite_team") as? String
                    if favouriteCountry != nil && favouriteCountry != "" {
                        self.setTeamsAsRootViewController(favouriteCountry!)
                    }
                    else {
                        self.setMainAsRootViewController()
                    }
                    userRef.removeAllObservers()
                })
                
            }
            
        }
        else {
            setInitialAsRootViewController()
        }
    }
    
    func setInitialAsRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateViewControllerWithIdentifier("InitialNavigationController") as? UINavigationController {
            window?.rootViewController = initialViewController
        }
    }
    
    func setMainAsRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as? ViewController {
            window?.rootViewController = mainViewController
        }
    }
    
    func setTeamsAsRootViewController(favouriteCountry: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainViewController = storyboard.instantiateViewControllerWithIdentifier("TeamsTableViewController") as? TeamsTableViewController {
            mainViewController.country = favouriteCountry
            window?.rootViewController = mainViewController
        }
    }

    func setLoadingAsRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingViewController = storyboard.instantiateViewControllerWithIdentifier("LoadingViewController")
        window?.rootViewController = loadingViewController
    }
}

