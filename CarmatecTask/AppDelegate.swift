//
//  AppDelegate.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import UIKit
import FirebaseCore
import MapboxMaps
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let myAccessToken = "sk.eyJ1IjoicmFqYTAwMDciLCJhIjoiY2xtZHcyZ3k2MWk2YTNrbzV5aGtwc3FqMyJ9.6ajB-6OJfGBONFGmJp2ZOw"

        ResourceOptionsManager.default.resourceOptions.accessToken = myAccessToken
      
        
        let gIdConfiguration = GIDConfiguration(clientID:"952618648652-2faohcl1hg6n9kep97gd1g1brr9ha26b.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.configuration = gIdConfiguration
        return true
    }
}

