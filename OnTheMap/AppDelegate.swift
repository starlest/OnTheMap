//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Edwin Chia on 2/6/16.
//  Copyright © 2016 Edwin Chia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var studentLocations = [StudentLocation]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        /* Make sure user is logged out of Facebook at the start */
        Client.sharedInstance().attemptToLogoutFacebook()
        return true
    }
    
    func application(application: UIApplication,openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                                                                     annotation: options [UIApplicationOpenURLOptionsAnnotationKey])
    }
}

