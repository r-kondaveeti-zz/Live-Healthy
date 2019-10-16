//
//  AppDelegate.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSKinesis

@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //This is the JSON String with xyz coordinates (only passive data)
    var json: String = ViewController().generateJSON();
    
    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /** Initialize and push data to Kinesis Stream*/
//        print("Initializing Mobile Client")
//        AWSController().initializeAWSConnection()
//                AWSMobileClient.default().initialize { (userState, error) in
//            if let error = error {
//                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
//            } else if let userState = userState {
//                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
//            }
//        }
    
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return AWSMobileClient.default().interceptApplication(
            application, open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}

