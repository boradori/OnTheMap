//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/6/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import Reachability

let kREACHABLEWITHWIFI = "ReachableWithWIFI"
let kNOTREACHABLE = "NotReachable"
let kREACHABLEWITHWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var reachabilityStatus = kREACHABLEWITHWIFI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetReach: Reachability?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        
        
        do {
            internetReach = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Error! No internet connection!")
        }
        
        
        // startNotifier always listens to status change such as switching over from wifi to 3G
        do {
            try internetReach?.startNotifier()
        } catch {
            print("Notifier could not start")
        }
        
        if internetReach != nil {
            self.statusChangedWithReachability(internetReach!)
        }
        
        return true
    }
    
    func reachabilityChanged(notification: NSNotification) {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }
    
    
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        
        var networkStatus: Reachability.NetworkStatus = currentReachabilityStatus.currentReachabilityStatus
        var statusString: String = ""
        
        print("StatusValue: \(networkStatus.description)")
        print("StatusValue: \(networkStatus.hashValue)")
        
        if networkStatus.hashValue == Reachability.NetworkStatus.NotReachable.hashValue {
            print("Network not reachable")
            reachabilityStatus = kNOTREACHABLE
        } else if networkStatus.hashValue == Reachability.NetworkStatus.ReachableViaWiFi.hashValue {
            print("Reachable via WIFI")
            reachabilityStatus = kREACHABLEWITHWIFI
        } else if networkStatus.hashValue == Reachability.NetworkStatus.ReachableViaWWAN.hashValue {
            print("Reachable via WWAN")
            reachabilityStatus = kREACHABLEWITHWWAN
        }
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
    }


}

